;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define (interpretation:run! repository interpretation)
  (define guix
    (get-guix-executable))
  (define fetcher
    (get-fetcher/default))
  (define manifest
    (repository:manifest repository))
  (define manifest-path
    (manifest:path manifest))
  (define bin (repository:bin repository))
  (define bin-path (bin:path bin))
  (define state-dir (repository:state-directory repository))
  (define state-dir-path (state-directory:path state-dir))
  (define local-miyka-root-path
    (append-posix-path state-dir-path "imported"))
  (define versionfile
    (repository:versionfile repository))
  (define versionfile-path
    (versionfile:path versionfile))
  (define enter-script
    (repository:enter-script repository))
  (define enter-script-path
    (enter-script:path enter-script))
  (define setup-script
    (repository:setup-script repository))
  (define setup-script-path
    (setup-script:path setup-script))
  (define teardown-script
    (repository:teardown-script repository))
  (define teardown-script-path
    (teardown-script:path teardown-script))
  (define run-script
    (repository:run-script repository))
  (define run-script-path
    (run-script:path run-script))
  (define make-helper-env-script
    (repository:make-helper-env-script repository))
  (define make-helper-env-script-path
    (make-helper-env-script:path make-helper-env-script))
  (define id-map-add-repository-awkscript
    (repository:id-map-add-repository-awkscript repository))
  (define id-map-add-repository-awkscript-path
    (id-map-add-repository-awkscript:path id-map-add-repository-awkscript))
  (define run-sync-script
    (repository:run-sync-script repository))
  (define run-sync-script-path
    (run-sync-script:path run-sync-script))
  (define wrapper
    (repository:cleanup-wrapper repository))
  (define wrapper-path
    (cleanup-wrapper:path wrapper))
  (define packages
    (interpretation:installist interpretation))

  (define command
    (box-ref
     (interpretation:command interpretation)))

  (define importlist
    (reverse
     (stack->list
      (interpretation:import-stack interpretation))))

  (define cleanup
    (box-ref (interpretation:cleanup interpretation)))

  (define snapshot?
    (box-ref
     (interpretation:snapshot? interpretation)))

  (define environment
    (box-ref
     (interpretation:environment interpretation)))

  (define pure?
    (list? environment))

  (define maybe-pure
    (if pure? "--pure" ""))

  (define setup-command-list
    (stack-make))

  (define teardown-command-list
    (stack-make))

  (define make-temporary-command
    "
rm -rf -- \"$MIYKA_WORK_PATH/temporary\"
mkdir -p -- \"$MIYKA_WORK_PATH/temporary\"
")

  (define guix-describe-command
    "\"$MIYKA_GUIX_EXECUTABLE\" describe --format=channels > \"$MIYKA_WORK_PATH/state/channels.scm\"")

  (define snapshot-command
    "
#########################
# Snapshot with Restic. #
#########################

MIYKA_REPO_ID=\"$(cat -- \"$MIYKA_WORK_PATH/id.txt\")\"
MIYKA_GLOBALID_PATH=\"./globalid\"
HOSTNAME=\"$(cat -- '/etc/hostname')\"

cd -- \"$MIYKA_ROOT\"

if ! test -e ./backups
then
    restic init --quiet --repo ./backups --password-command 'echo 1234'
fi

if ! test -f \"$MIYKA_GLOBALID_PATH\"
then
    cat -- '/dev/urandom' | base32 | head -c 16  > \"$MIYKA_GLOBALID_PATH\"
fi

MIYKA_GLOBALID=\"$(cat -- \"$MIYKA_GLOBALID_PATH\")\"

if ! restic backup --quiet --repo ./backups --password-command 'echo 1234' --tag id:\"$MIYKA_REPO_ID\" --tag time:$(date +%s) --tag action:exit --tag hostname:\"$HOSTNAME\" --tag globalid:\"$MIYKA_GLOBALID\" -- \"repositories/$MIYKA_REPO_ID/wd\"
then
    echo 'Backup with restic failed.' 1>&2
fi

cd - 1>/dev/null 2>/dev/null

")

  (define setup-command
    "
##############################
# Invoking the setup script. #
##############################

if ! \"$2\" shell \\
    --pure \\
    coreutils gawk restic \\
    -- \\
    /bin/sh -- \"$1\"/make-helper-env.sh \"$1\" \"$2\" \"$3\" \"$4\" \"$5\" /bin/sh -- \"$1\"/setup.sh
then
    echo 'Setup script failed. Will not proceed further.' 1>&2
    exit 1
fi

")

  (define import-directory-function
    "
#######################
# Import directories. #
#######################

LOCAL_BIN_PATH=\"$MIYKA_WORK_PATH\"/bin
LOCAL_MIYKA_ROOT=\"$MIYKA_STAT_PATH/imported\"
LOCAL_ID_MAP=\"$LOCAL_MIYKA_ROOT\"/id-map.csv

IMPORTED_REPOSITORIES_NAMES=\"$MIYKA_WORK_PATH\"/temporary/imported_names
rm -rf -- \"$IMPORTED_REPOSITORIES_NAMES\"
mkdir -p -- \"$IMPORTED_REPOSITORIES_NAMES\"

mkdir -p -- \"$LOCAL_MIYKA_ROOT\"/repositories
if ! test -f \"$LOCAL_ID_MAP\"
then
    echo \"id,name\" > \"$LOCAL_ID_MAP\"
fi

import_directory() {
    NAME=\"$1\"
    shift

    EXECUTABLE_PATH=\"$LOCAL_BIN_PATH\"/\"$NAME\"
    if test -f \"$EXECUTABLE_PATH\"
    then
        echo \"Repository '$NAME' already imported.\" 1>&2
        echo > \"$IMPORTED_REPOSITORIES_NAMES\"/\"$NAME\"
        return 0
    fi

    LOCATION=\"$1\"
    shift

    case \"$LOCATION\" in
        /*)
            ROOT_PATH=\"$LOCATION\"
            ;;
        *)
            ROOT_PATH=\"$MIYKA_REPO_HOME/$LOCATION\"
            ;;
    esac

    if ! test -d \"$ROOT_PATH\"
    then
        echo \"Repository directory '$LOCATION' does not exist.\" 1>&2
        exit 1
    fi

    ID_PATH=\"$ROOT_PATH\"/wd/id.txt
    if ! test -f \"$ID_PATH\"
    then
        echo \"Imported repository at '$LOCATION' does not have an id file at '$LOCATION/wd/id.txt'.\" 1>&2
        exit 1
    fi

    RUN_SCRIPT_PATH=\"$ROOT_PATH\"/wd/state/run.sh
    if ! test -f \"$RUN_SCRIPT_PATH\"
    then
        echo \"Imported repository at '$LOCATION' does not have a run file at '$LOCATION/wd/state/run.sh'.\" 1>&2
        exit 1
    fi

    REPO_ID=\"$(cat -- \"$ID_PATH\")\"
    # FIXME: check if $REPO_ID is in the right format.

    # Copy repository directory.
    TARGET_ROOT_PATH=\"$LOCAL_MIYKA_ROOT\"/repositories/\"$REPO_ID\"
    rm -rf -- \"$TARGET_ROOT_PATH\"
    cp -r -T -- \"$ROOT_PATH\" \"$TARGET_ROOT_PATH\"

    # Register id in 'id-map.csv'.
    TMP_ID_MAP=\"$MIYKA_WORK_PATH/temporary/$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 10).csv\"
    cat -- \"$LOCAL_ID_MAP\" | awk -v new_id=\"$REPO_ID\" -v new_name=\"$NAME\" -f \"$MIYKA_STAT_PATH\"/id-map-add-repository.awk > \"$TMP_ID_MAP\"
    mv -T -- \"$TMP_ID_MAP\" \"$LOCAL_ID_MAP\"

    # Create a link.
    mkdir -p -- \"$LOCAL_BIN_PATH\"
    printf '#! /bin/sh
exec /bin/sh -- \"${0%%/*}/../state/imported/repositories/%s/wd/state/run.sh\"
' \"$REPO_ID\" > \"$EXECUTABLE_PATH\"
    chmod u+x -- \"$EXECUTABLE_PATH\"

    # Record import.
    echo > \"$IMPORTED_REPOSITORIES_NAMES\"/\"$NAME\"
}
")

  (define unimport-directories
    "
##########################
# Unimport repositories. #
##########################

LOCAL_BIN_PATH=\"$MIYKA_WORK_PATH\"/bin
LOCAL_MIYKA_ROOT=\"$MIYKA_STAT_PATH/imported\"
LOCAL_ID_MAP=\"$LOCAL_MIYKA_ROOT\"/id-map.csv

remove_repository_directory() {
    REPO_ID=\"$1\"
    shift
    TARGET_ROOT_PATH=\"$1\"
    shift

    TMP_ID_MAP=\"$MIYKA_WORK_PATH/temporary/$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 10).csv\"
    cat -- \"$LOCAL_ID_MAP\" | awk -v new_id=\"$REPO_ID\" -F ',' '{ id = $1 ; if (id == new_id) { } else { print $0 } }' > \"$TMP_ID_MAP\"
    mv -T -- \"$TMP_ID_MAP\" \"$LOCAL_ID_MAP\"

    rm -v -rf -- \"$TARGET_ROOT_PATH\" 1>&2
}

remove_repository_binary() {
    BINARY_PATH=\"$1\"
    shift

    rm -v -rf -- \"$BINARY_PATH\" 1>&2
}

for TARGET_ROOT_PATH in \"$LOCAL_MIYKA_ROOT\"/repositories/*
do
    REPO_ID=\"$(basename -- \"$TARGET_ROOT_PATH\")\"
    if test \"$REPO_ID\" = '*'
    then continue
    fi

    NAME=\"$(cat -- \"$LOCAL_ID_MAP\" | awk -v new_id=\"$REPO_ID\" -F ',' '{ id = $1 ; name = $2 ; if (id == new_id) { print name } }')\"
    REGISTERED_NAME=\"$IMPORTED_REPOSITORIES_NAMES\"/\"$NAME\"
    if ! test -f \"$REGISTERED_NAME\"
    then
        echo \"Repository directory with id '$REPO_ID' and name \"$NAME\" is not imported.\" 1>&2
        remove_repository_directory \"$REPO_ID\" \"$TARGET_ROOT_PATH\"
    fi
done

for BINARY_PATH in \"$LOCAL_BIN_PATH\"/*
do
    NAME=\"$(basename -- \"$BINARY_PATH\")\"
    if test \"$NAME\" = '*'
    then continue
    fi

    REGISTERED_NAME=\"$IMPORTED_REPOSITORIES_NAMES\"/\"$NAME\"
    if ! test -f \"$REGISTERED_NAME\"
    then
        echo \"Repository directory named '$NAME' is not imported.\" 1>&2
        remove_repository_binary \"$BINARY_PATH\"
    fi
done

")

  (define import-custom-function
    "
##################
# Import custom. #
##################

LOCAL_TEMPORARY_IMPORTS=\"$MIYKA_WORK_PATH\"/temporary/imports
mkdir -p -- \"$LOCAL_TEMPORARY_IMPORTS\"

import_custom() {
    NAME=\"$1\"
    shift

    EXECUTABLE_PATH=\"$LOCAL_BIN_PATH\"/\"$NAME\"
    if test -f \"$EXECUTABLE_PATH\"
    then
        echo \"Repository '$NAME' already imported.\" 1>&2
        echo > \"$IMPORTED_REPOSITORIES_NAMES\"/\"$NAME\"
        return 0
    fi

    export MIYKA_FETCHER_ARG_ID=\"$1\"
    shift
    export MIYKA_FETCHER_ARG_NAME=\"$1\"
    shift

    if test -z \"$MIYKA_FETCHER\"
    then
        echo 'Fetcher is required for importing anything but directories.' 1>&2
        return 1
    fi

    export MIYKA_FETCHER_ARG_DESTINATION=\"$LOCAL_TEMPORARY_IMPORTS/$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 10)\"
    echo \"Fetching '$NAME'...\" 1>&2
    \"$MIYKA_FETCHER\"
    echo \"Fetching '$NAME' finished.\" 1>&2
    # TODO: check if fetcher succeeded.
    import_directory \"$NAME\" \"$MIYKA_FETCHER_ARG_DESTINATION\"
}
")

  (define directories-importlist
    (filter directory-import-statement? importlist))

  (define import-directories-command
    (with-output-stringified
     (for-each
      (lambda (im)
        (display "import_directory")
        (display " ")
        (write (~a (directory-import-statement:new-name im)))
        (display " ")
        (write (~a (directory-import-statement:path im)))
        (newline)
        )
      directories-importlist)))

  (define custom-importlist
    (filter (negate directory-import-statement?) importlist))

  (define need-temporary?
    (not (null? importlist)))

  (define import-custom-command
    (with-output-stringified
     (for-each
      (lambda (im)
        (cond
         ((id-import-statement? im)
          (display "import_custom")
          (display " ")
          (write (~a (id-import-statement:new-name im)))
          (display " ")
          (write (~a (id-import-statement:value im)))
          (display " ")
          (write "")
          (newline))

         ((name-import-statement? im)
          (display "import_custom")
          (display " ")
          (write (~a (name-import-statement:new-name im)))
          (display " ")
          (write "")
          (display " ")
          (write (~a (name-import-statement:value im)))
          (newline))

         (else
          (raisu* :from "interpretation-run!"
                  :type 'bad-type-of-import
                  :message "Import has bad type."
                  :args (list im)))))
      custom-importlist)))

  (define teardown-command
    "
########################
# The teardown script. #
########################

teardown() {

if ! \"$2\" shell \\
    --pure \\
    coreutils gawk restic \\
    -- \\
    /bin/sh -- \"$1\"/make-helper-env.sh \"$1\" \"$2\" \"$3\" \"$4\" \"$5\" /bin/sh -- \"$1\"/teardown.sh
then
    echo 'Teardown script failed.' 1>&2
fi

}

trap 'teardown \"$1\" \"$2\" \"$3\" \"$4\"' exit hup int quit abrt kill alrm term

")

  (define guix-part-of-enter-command
    (if (and (null? packages) (not pure?)) '()
        (list
         "\"$2\""
         "shell"
         maybe-pure
         "--manifest=\"$1\"/manifest.scm"
         "--")))

  (define script-part-of-enter-command
    (list-collapse
     (list
      "/bin/sh" "--" "\"$1\"/enter.sh" "\"$1\"/../home"
      (map
       (lambda (name)
         (~s (string-append "$" name)))
       (or environment '()))
      "\"$1\"/../home")))

  (define enter-command
    (words->string
     (append
      guix-part-of-enter-command
      script-part-of-enter-command)))

  (when need-temporary?
    (stack-push! setup-command-list make-temporary-command))

  (unless (null? packages)
    (stack-push! setup-command-list guix-describe-command))

  (when (and guix
             (not (equal? "" guix))
             (not (absolute-posix-path? guix)))
    (raisu-fmt
     'guix-path-must-be-absolute
     "Path to guix executable ($~a) must be absolute, but isn't: ~s."
     guix-executable-env-variable-name
     guix))

  (unless (null? importlist)
    (stack-push! setup-command-list import-directory-function))

  (unless (null? directories-importlist)
    (stack-push! setup-command-list import-directories-command))

  (unless (null? custom-importlist)
    (stack-push! setup-command-list import-custom-function)
    (stack-push! setup-command-list import-custom-command))

  (unless (null? importlist)
    (stack-push! setup-command-list unimport-directories))

  (when need-temporary?
    (stack-push!
     teardown-command-list
     make-temporary-command))

  (when snapshot?
    (stack-push!
     teardown-command-list
     snapshot-command))

  (let ()
    (define script
      (repository:enter-script repository))
    (define path
      (enter-script:path script))
    (define dirpath
      (path-get-dirname path))

    (make-directories dirpath))

  (call-with-output-file/lazy
   make-helper-env-script-path
   (lambda (port)
     (display make-helper-env-script:template port)))

  (call-with-output-file/lazy
   id-map-add-repository-awkscript-path
   (lambda (port)
     (display id-map-add-repository-awkscript:template port)))

  (call-with-output-file/lazy
   versionfile-path
   (lambda (port)
     (display miyka:version port)
     (newline port)))

  (unless (stack-empty? setup-command-list)
    (call-with-output-file/lazy
     setup-script-path
     (lambda (port)
       (display "#! /bin/sh" port)
       (newline port)
       (newline port)
       (display "set -e" port)
       (newline port)
       (newline port)

       (for-each
        (lambda (line) (display line port) (newline port) (newline port))
        (reverse
         (stack->list setup-command-list))))))

  (unless (stack-empty? teardown-command-list)
    (call-with-output-file/lazy
     teardown-script-path
     (lambda (port)
       (display "#! /bin/sh" port)
       (newline port)
       (newline port)

       (for-each
        (lambda (line) (display line port) (newline port) (newline port))
        (reverse
         (stack->list teardown-command-list))))))

  (call-with-output-file/lazy
   run-sync-script-path
   (lambda (port)
     (display "#! /bin/sh" port)
     (newline port)
     (newline port)
     (unless (stack-empty? teardown-command-list)
       (display teardown-command port))
     (unless (stack-empty? setup-command-list)
       (display setup-command port))
     (display enter-command port)
     (newline port)))

  (call-with-output-file/lazy
   manifest-path
   (lambda (port)
     (write
      `(specifications->manifest
        (quote ,packages))
      port)))

  (call-with-output-file/lazy
   enter-script-path

   (lambda (port)

     (define path-value
       (if (null? importlist)
           ""
           "export PATH=\"$1\"/../bin:\"$PATH\""))

     (define cleanup-command
       (if cleanup
           (stringf "cd \"$1\" && test -f ./~s && /bin/sh -- ./~s" cleanup cleanup)
           "true"))

     (define env-definitions
       (lines->string
        (map
         (lambda (name)
           (stringf "export ~a=\"$1\"
shift" name))
         (or environment '()))))

     (define command/str
       (if (command:shell? command)
           (stringf "/bin/sh -- \"$1\"/~s" (command:shell:path command))
           ""))

     (fprintf
      port
      enter-script:template
      cleanup-command
      env-definitions
      path-value
      command/str)))

  (call-with-output-file/lazy
   run-script-path
   (lambda (port)
     (display run-script:template port)))

  (when (null? importlist)
    (when (file-or-directory-exists? bin-path)
      (system*/exit-code "rm" "-rf" "--" bin-path)
      (make-directories bin-path))
    (when (file-or-directory-exists? local-miyka-root-path)
      (system*/exit-code "rm" "-rf" "--" local-miyka-root-path)))

  (system*/exit-code
   "/bin/sh" "--"
   run-script-path
   (or guix "")
   (or fetcher "")))
