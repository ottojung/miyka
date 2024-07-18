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
  (define versionfile
    (repository:versionfile repository))
  (define versionfile-path
    (versionfile:path versionfile))
  (define enter-script
    (repository:enter-script repository))
  (define enter-script-path
    (enter-script:path enter-script))
  (define relative-path-script
    (repository:relative-path-script repository))
  (define relative-path-script-path
    (relative-path-script:path relative-path-script))
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

  (define host-locations
    (reverse
     (stack->list
      (interpretation:host-stack interpretation))))

  (define importlist
    (reverse
     (stack->list
      (interpretation:import-stack interpretation))))

  (define cleanup
    (box-ref (interpretation:cleanup interpretation)))

  (define home-moved?
    (box-ref
     (interpretation:home-moved? interpretation)))

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
    coreutils grep findutils procps sed gawk nss-certs restic make openssh gnupg \\
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
LOCAL_ID_MAP=\"$LOCAL_MIYKA_ROOT\"/id-map.toml
mkdir -p -- \"$LOCAL_MIYKA_ROOT\"/repositories
echo '()' > \"$LOCAL_ID_MAP\"

import_directory() {
    NAME=\"$1\"
    shift

    EXECUTABLE_PATH=\"$LOCAL_BIN_PATH\"/\"$NAME\"
    if test -f \"$EXECUTABLE_PATH\"
    then
        echo \"Repository '$NAME' already imported.\" 1>&2
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
    cp -r -T -- \"$ROOT_PATH\" \"$TARGET_ROOT_PATH\"

    # Register id in 'id-map.toml'.
    echo \"[[repository]]
name = \\\"$NAME\\\"
id = \\\"$REPO_ID\\\"

\" >> \"$LOCAL_ID_MAP\"

    # Create a link.
    mkdir -p -- \"$LOCAL_BIN_PATH\"
    printf '#! /bin/sh
exec /bin/sh -- \"${0%%/*}/../state/imported/repositories/%s/wd/state/run.sh\"
' \"$REPO_ID\" > \"$EXECUTABLE_PATH\"
    chmod u+x -- \"$EXECUTABLE_PATH\"
}
")

  (define import-custom-function
    "
##################
# Import custom. #
##################

if test -z \"$MIYKA_FETCHER\"
then
    echo 'Fetcher is required for importing anything but directories.' 1>&2
    false
fi

import_custom() {
    NAME=\"$1\"
    shift

    EXECUTABLE_PATH=\"$LOCAL_BIN_PATH\"/\"$NAME\"
    if test -f \"$EXECUTABLE_PATH\"
    then
        echo \"Repository '$NAME' already imported.\" 1>&2
        return 0
    fi

    export MIYKA_FETCHER_ARG_ID=\"$1\"
    shift
    export MIYKA_FETCHER_ARG_NAME=\"$1\"
    shift

    export MIYKA_FETCHER_ARG_DESTINATION=\"$MIYKA_WORK_PATH/temporary/imports/$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 10)\"
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
    coreutils grep findutils procps sed gawk nss-certs restic make openssh gnupg \\
    -- \\
    /bin/sh -- \"$1\"/make-helper-env.sh \"$1\" \"$2\" \"$3\" \"$4\" \"$5\" /bin/sh -- \"$1\"/teardown.sh
then
    echo 'Teardown script failed.' 1>&2
fi

}

trap 'teardown \"$1\" \"$2\" \"$3\" \"$4\"' exit hup int quit abrt kill alrm term

")

  (define enter-command
    (words->string
     (list-collapse
      (list
       "\"$2\""
       "shell"
       maybe-pure
       "--manifest=\"$1\"/manifest.scm"
       "--"
       "/bin/sh" "--" "\"$1\"/enter.sh" "\"$1\"/../home"
       (map
        (lambda (name)
          (~s (string-append "$" name)))
        (or environment '()))
       "\"$1\"/../home"
       ))))

  (unless (null? packages)
    (stack-push! setup-command-list make-temporary-command))

  (unless (null? packages)
    (stack-push! setup-command-list guix-describe-command))

  (unless (null? host-locations)
    (stack-push!
     setup-command-list
     (stringf "
####################
# Link host files. #
####################

MIYKA_HOME_LINK=\"$MIYKA_WORK_PATH/temporary/miyka-orig-home\"
ln -sT -- \"$MIYKA_ORIG_HOME\" \"$MIYKA_HOME_LINK\"

for LOCATION in ~a
do
    if test -e \"$MIYKA_REPO_HOME/$LOCATION\"
    then continue
    fi

    if test -L \"$MIYKA_REPO_HOME/$LOCATION\"
    then continue
    fi

    if test -e \"$MIYKA_HOME_LINK/$LOCATION\"
    then
        case \"$LOCATION\" in
            */)
                if ! test -d \"$MIYKA_HOME_LINK/$LOCATION\"
                then echo \"Host path \\\"$LOCATION\\\" expected to be a directory.\" 1>&2 ; exit 1
                fi
                ;;
            *)
                if ! test -f \"$MIYKA_HOME_LINK/$LOCATION\"
                then echo \"Host path \\\"$LOCATION\\\" expected to be a regular file.\" 1>&2 ; exit 1
                fi
                ;;
        esac
    fi

    case \"$LOCATION\" in
       */)
            LOCATION=\"${LOCATION%/}\"    # remove trailing slash.

            if ! test -e \"$MIYKA_HOME_LINK/$LOCATION\"
            then mkdir -v -p -- \"$MIYKA_HOME_LINK/$LOCATION\"
            fi
            ;;
    esac

    mkdir -p -- \"$(dirname -- \"$MIYKA_REPO_HOME/$LOCATION\")\"

    if test -d \"$MIYKA_HOME_LINK/$LOCATION\"
    then
        LINK_VALUE=\"$(echo | awk -v first_path=\"home/$LOCATION/..\" -v second_path=\"temporary/miyka-orig-home/$LOCATION\" -f \"$MIYKA_WORK_PATH/state/relative-path.awk\")\"
        ln -sT -- \"$LINK_VALUE\" \"$MIYKA_REPO_HOME/$LOCATION\"   1>&2
    else
        if test -f \"$MIYKA_ORIG_HOME/$LOCATION\"
        then cp -T  -- \"$MIYKA_ORIG_HOME/$LOCATION\" \"$MIYKA_REPO_HOME/$LOCATION\"   1>&2
        else continue
        fi
    fi

    echo \"HOST $LOCATION\" 1>&2
done

" (words->string (map ~s host-locations)))))

  (when (and fetcher
             (not (equal? "" fetcher))
             (not (absolute-posix-path? fetcher)))
    (raisu-fmt
     'fetcher-path-must-be-absolute
     "Fetcher path ($~a) must be absolute, but isn't: ~s."
     fetcher-var-name
     fetcher))

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

  (stack-push!
   teardown-command-list
   make-temporary-command)

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
   relative-path-script-path
   (lambda (port)
     (display relative-path-script:template port)))

  (call-with-output-file/lazy
   make-helper-env-script-path
   (lambda (port)
     (display make-helper-env-script:template port)))

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
     (display teardown-command port)
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
       "export PATH=\"$PATH\":\"$1\"/../bin")

     (define cleanup-command
       (if cleanup
           (stringf "cd \"$1\" && test -f ./~s && /bin/sh -- ./~s" cleanup cleanup)
           "true"))

     (define home-command
       (if home-moved?
           "HOME=\"$1\""
           ""))

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
      home-command
      path-value
      env-definitions
      command/str)))

  (call-with-output-file/lazy
   run-script-path
   (lambda (port)
     (display run-script:template port)))

  (system*/exit-code
   "/bin/sh" "--"
   run-script-path
   (or guix "")
   (or fetcher "")))
