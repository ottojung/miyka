;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define (interpretation:run! repository interpretation)
  (define guix
    (get-guix-executable))
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

  (define commands
    (reverse
     (stack->list
      (interpretation:commands interpretation))))

  (define host-locations
    (reverse
     (stack->list
      (interpretation:host-stack interpretation))))

  (define gitlist
    (reverse
     (stack->list
      (interpretation:git-stack interpretation))))

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

  (define maybe-move-home
    (if home-moved? "--move-home" ""))

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
    coreutils grep findutils procps sed gawk nss-certs restic git make openssh gnupg \\
    -- \\
    /bin/sh -- \"$1\"/make-helper-env.sh \"$1\" \"$2\" \"$3\" /bin/sh -- \"$1\"/setup.sh
then
    echo 'Setup script failed. Will not proceed further.' 1>&2
    exit 1
fi

")

  (define teardown-command
    "
########################
# The teardown script. #
########################

teardown() {

if ! \"$2\" shell \\
    --pure \\
    coreutils grep findutils procps sed gawk nss-certs restic git make openssh gnupg \\
    -- \\
    /bin/sh -- \"$1\"/make-helper-env.sh \"$1\" \"$2\" \"$3\" /bin/sh -- \"$1\"/teardown.sh
then
    echo 'Teardown script failed.' 1>&2
fi

}

trap 'teardown \"$1\" \"$2\" \"$3\"' exit hup int quit abrt kill alrm term

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

  (unless (null? gitlist)
    (stack-push!
     setup-command-list
     (stringf
      "
##############################
# Deploy git configurations. #
##############################

mkdir -p -- \"$MIYKA_WORK_PATH/state/git\"
mkdir -p -- \"$MIYKA_WORK_PATH/state/git-lock\"

for REPO in ~a
do
    NAME=\"$(basename -- \"$REPO\")\"

    if test -e \"$MIYKA_WORK_PATH/state/git-lock/$NAME\"
    then continue
    fi

    if test -e \"$MIYKA_WORK_PATH/state/git/$NAME\"
    then
        cd -- \"$MIYKA_WORK_PATH/state/git/$NAME\"

        if grep -q '^miyka-initialize:' 'Makefile'
        then make miyka-uninitialize PREFIX=\"$MIYKA_REPO_HOME/.local\" || true
        else make uninstall PREFIX=\"$MIYKA_REPO_HOME/.local\" || true
        fi

        cd - 1>/dev/null 2>/dev/null
    fi

    rm -rf -- \"$MIYKA_WORK_PATH/state/git/$NAME\"
    rm -f -- \"$MIYKA_WORK_PATH/state/git-lock/$NAME\"

    git clone --recursive --depth 1 -- \"$REPO\" \"$MIYKA_WORK_PATH/state/git/$NAME\"
    cd -- \"$MIYKA_WORK_PATH/state/git/$NAME\"

    if grep -q '^miyka-initialize:' 'Makefile'
    then make miyka-initialize PREFIX=\"$MIYKA_REPO_HOME/.local\"
    else make install PREFIX=\"$MIYKA_REPO_HOME/.local\"
    fi

    cd - 1>/dev/null 2>/dev/null
    git -C \"$MIYKA_WORK_PATH/state/git/$NAME\" rev-parse HEAD > \"$MIYKA_WORK_PATH/state/git-lock/$NAME\"
    rm -rf -- \"$MIYKA_WORK_PATH/state/git/$NAME/.git\"

done

"
      (words->string (map ~s gitlist)))))

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
       "\"$1\"/.local/bin:\"$PATH\":\"$1\"/../bin")

     (define cleanup-command
       (if cleanup
           (stringf "test -f \"$1\"/~s && /bin/sh -- \"$1\"/~s" cleanup cleanup)
           "true"))

     (define env-definitions
       (lines->string
        (map
         (lambda (name)
           (stringf "export ~a=\"$1\"
shift" name))
         (or environment '()))))

     (define command/list
       (filter
        identity
        (map
         (lambda (command)
           (and (command:shell? command)
                (stringf "/bin/sh -- \"$1\"/~s" (command:shell:path command))))
         commands)))

     (define command
       (if (null? command/list)
           "" (car command/list)))

     (fprintf
      port
      enter-script:template
      cleanup-command
      path-value
      env-definitions
      command)))

  (call-with-output-file/lazy
   run-script-path
   (lambda (port)
     (display run-script:template port)))

  (system*/exit-code
   "/bin/sh" "--"
   run-script-path
   (or (guix-executable/p) "")))
