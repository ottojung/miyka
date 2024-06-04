;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define (interpretation:run! repository interpretation)
  (define guix
    (get-guix-executable))
  (define manifest
    (repository:manifest repository))
  (define manifest-path
    (manifest:path manifest))
  (define enter-script
    (repository:enter-script repository))
  (define enter-script-path
    (enter-script:path enter-script))
  (define ps-script
    (repository:ps-script repository))
  (define ps-script-path
    (ps-script:path ps-script))
  (define setup-script
    (repository:setup-script repository))
  (define setup-script-path
    (setup-script:path setup-script))
  (define run-script
    (repository:run-script repository))
  (define run-script-path
    (run-script:path run-script))
  (define run-sync-script
    (repository:run-sync-script repository))
  (define run-sync-script-path
    (run-sync-script:path run-sync-script))
  (define run-async-script
    (repository:run-async-script repository))
  (define run-async-script-path
    (run-async-script:path run-async-script))
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

  (define (make-enter-script script-path footer)
    (call-with-output-file
        script-path
      (lambda (port)
        (define home-line
          (if home-moved?
              "export HOME=\"$MIYKA_REPO_HOME\""
              ""))
        (fprintf
         port
         enter-script:template
         home-line
         footer))))

  (define cleanup
    (box-ref (interpretation:cleanup interpretation)))

  (define home-moved?
    (box-ref
     (interpretation:home-moved? interpretation)))

  (define snapshot?
    (box-ref
     (interpretation:snapshot? interpretation)))

  (define pure?
    (box-ref
     (interpretation:pure? interpretation)))

  (define maybe-pure
    (if pure? "--pure" ""))

  (define maybe-move-home
    (if home-moved? "--move-home" ""))

  (define setup-command-list
    (stack-make))

  (define sync-footer
    (stack-make))

  (define async-footer
    (stack-make))

  (define current-footer
    sync-footer)

  (define cleanup-command
    (stringf "test -f ~s && MIYKA_PROC_ID=$MIYKA_PID_SYNC sh -- ~s" cleanup cleanup))

  (define cleanup-wrapper
    (let ()
      (define base "
rm -rf -- \"$MIYKA_REPO_PATH/wd/tmp\"
mkdir -p -- \"$MIYKA_REPO_PATH/wd/tmp\"
ln -sT -- \"$MIYKA_ORIG_HOME\" \"$MIYKA_REPO_PATH/wd/tmp/miyka-orig-home\"
")
      (if cleanup
          (stringf "~a\n~a" base cleanup-command)
          base)))

  (define guix-describe-command
    "\"$MIYKA_GUIX_EXECUTABLE\" describe --format=channels > \"$MIYKA_REPO_HOME/.config/miyka/channels.scm\"")

  (define snapshot-command
    "
#########################
# Snapshot with Restic. #
#########################

MIYKA_REAL_REPO_PATH=\"$(readlink -f -- \"$MIYKA_REPO_PATH\")\"
MIYKA_REPO_NAME=\"$(basename -- \"$MIYKA_REAL_REPO_PATH\")\"
MIYKA_REPO_ID=\"$(cat -- \"$MIYKA_REPO_PATH/wd/var/miyka/id\")\"

cd -- \"$MIYKA_ROOT\"

if ! test -e ./backups
then
    restic init --quiet --repo ./backups --password-command 'echo 1234'
fi

if ! restic backup --quiet --repo ./backups --password-command 'echo 1234' --tag id:\"$MIYKA_REPO_ID\" --tag time:$(date +%s) --tag action:exit -- \"repositories/$MIYKA_REPO_NAME/wd\"
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

if ! HOME=\"$MIYKA_ORIG_HOME\" \"$MIYKA_GUIX_EXECUTABLE\" shell \\
    --pure \\
    coreutils grep findutils procps sed gawk nss-certs restic git make openssh gnupg \\
    -- \\
    /bin/sh -- \"$MIYKA_REPO_HOME/.config/miyka/setup.sh\" \\
    \"$MIYKA_REPO_HOME\" \"$MIYKA_REPO_PATH\" \"$MIYKA_ORIG_HOME\" \"$MIYKA_ROOT\" \"$MIYKA_GUIX_EXECUTABLE\"
then
    echo 'Setup script failed. Will not proceed further.' 1>&2
    exit 1
fi

")

  (unless (null? packages)
    (stack-push! setup-command-list guix-describe-command))

  (unless (null? host-locations)
    (stack-push!
     setup-command-list
     (stringf "
####################
# Link host files. #
####################

MIYKA_HOME_LINK=\"$MIYKA_REPO_PATH/wd/tmp/miyka-orig-home\"

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
                if test -d \"$MIYKA_HOME_LINK/$LOCATION\"
                then echo \"Host path \\\"$LOCATION\\\" not expected to be a directory.\" 1>&2 ; exit 1
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
    ln -svT -- \"$MIYKA_HOME_LINK/$LOCATION\" \"$MIYKA_REPO_HOME/$LOCATION\"   1>&2
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

mkdir -p -- \"$MIYKA_REPO_HOME/.config/miyka/git-repos\"
mkdir -p -- \"$MIYKA_REPO_PATH/wd/var/miyka/git-lock\"

for REPO in ~a
do
    NAME=\"$(basename -- \"$REPO\")\"

    if test -e \"$MIYKA_REPO_PATH/wd/var/miyka/git-lock/$NAME\"
    then continue
    fi

    if test -e \"$MIYKA_REPO_HOME/.config/miyka/git-repos/$NAME\"
    then
        cd -- \"$MIYKA_REPO_HOME/.config/miyka/git-repos/$NAME\"

        if grep -q '^miyka-initialize:' 'Makefile'
        then make miyka-uninitialize PREFIX=\"$MIYKA_REPO_HOME/.local\" || true
        else make uninstall PREFIX=\"$MIYKA_REPO_HOME/.local\" || true
        fi

        cd - 1>/dev/null 2>/dev/null
    fi

    rm -rf -- \"$MIYKA_REPO_HOME/.config/miyka/git-repos/$NAME\"
    rm -f -- \"$MIYKA_REPO_PATH/wd/var/miyka/git-lock/$NAME\"

    git clone --recursive --depth 1 -- \"$REPO\" \"$MIYKA_REPO_HOME/.config/miyka/git-repos/$NAME\"
    cd -- \"$MIYKA_REPO_HOME/.config/miyka/git-repos/$NAME\"

    if grep -q '^miyka-initialize:' 'Makefile'
    then make miyka-initialize PREFIX=\"$MIYKA_REPO_HOME/.local\"
    else make install PREFIX=\"$MIYKA_REPO_HOME/.local\"
    fi

    cd - 1>/dev/null 2>/dev/null
    git -C \"$MIYKA_REPO_HOME/.config/miyka/git-repos/$NAME\" rev-parse HEAD > \"$MIYKA_REPO_PATH/wd/var/miyka/git-lock/$NAME\"
    rm -rf -- \"$MIYKA_REPO_HOME/.config/miyka/git-repos/$NAME/.git\"

done

"
      (words->string (map ~s gitlist)))))

  (stack-push! sync-footer cleanup-wrapper)

  (unless (stack-empty? setup-command-list)
    (stack-push! sync-footer setup-command))

  (for-each
   (lambda (command)
     (cond
      ((command:detach? command)
       (set! current-footer async-footer))

      ((command:shell? command)
       (stack-push!
        current-footer
        (stringf "MIYKA_PROC_ID=$MIYKA_PID_SYNC sh -- ~s" (command:shell:path command))))

      (else
       (raisu* :from "interpretation:run!"
               :type 'unknown-command
               :message (stringf "Uknown command ~s." command)
               :args (list command)))))
   commands)

  (unless (stack-empty? async-footer)
    (stack-push!
     sync-footer
     "{ sh -- \"$MIYKA_REPO_HOME/.config/miyka/run-async.sh\" & } &"))

  (let ()
    (define cleanup-footer
      (cond
       ((not (stack-empty? current-footer))
        current-footer)
       ((not (stack-empty? sync-footer))
        sync-footer)
       (else
        current-footer)))

    (stack-push!
     cleanup-footer
     "RETURN_CODE=$?")

    (stack-push!
     cleanup-footer
     "
 ############################
 # Kill dangling processes. #
 ############################

\"$MIYKA_GUIX_EXECUTABLE\" shell coreutils grep procps gawk findutils --pure -- /bin/sh -c \"
MIYKA_REPO_HOME=$MIYKA_REPO_HOME
MIYKA_PID_SYNC=$MIYKA_PID_SYNC
\"'

get_pids() {
    for PID in $(ps -a -o pid | tail -n +2)
    do
        test -e \"/proc/$PID/environ\" || continue
        if cat \"/proc/$PID/environ\" | tr \"\\0\" \"\\n\" | grep -q -e \"^MIYKA_PROC_ID=$MIYKA_PID_SYNC\"
        then echo \"$PID\"
        fi
    done
}

for PID in $(get_pids) ; do kill -15 $PID ; done
sleep 5
for PID in $(get_pids) ; do kill -9 $PID ; done

'
")

    (stack-push!
     cleanup-footer
     cleanup-wrapper)

    (when snapshot?
      (stack-push!
       cleanup-footer
       snapshot-command))

    (stack-push!
     cleanup-footer
     "exit $RETURN_CODE"))

  (let ()
    (define script
      (repository:enter-script repository))
    (define path
      (enter-script:path script))
    (define dirpath
      (path-get-dirname path))

    (make-directories dirpath)
    (call-with-output-file
        path
      (lambda (port)
        (fprintf port enter-script:template))))

  (call-with-output-file
      ps-script-path
    (lambda (port)
      (display ps-script:template port)))

  (unless (stack-empty? setup-command-list)
    (call-with-output-file
        setup-script-path
      (lambda (port)
        (display "#! /bin/sh" port)
        (newline port)
        (newline port)
        (display "set -e" port)
        (newline port)
        (newline port)

        (display "export MIYKA_REPO_HOME=\"$1\"" port)
        (newline port)
        (display "export MIYKA_REPO_PATH=\"$2\"" port)
        (newline port)
        (display "export MIYKA_ORIG_HOME=\"$3\"" port)
        (newline port)
        (display "export MIYKA_ROOT=\"$4\"" port)
        (newline port)
        (display "export MIYKA_GUIX_EXECUTABLE=\"$5\"" port)
        (newline port)
        (display "export PATH=\"$PATH:$MIYKA_REPO_PATH/wd/bin\"" port)
        (newline port)
        (newline port)

        (for-each
         (lambda (line) (display line port) (newline port) (newline port))
         (reverse
          (stack->list setup-command-list))))))

  (call-with-output-file
      run-sync-script-path
    (lambda (port)
      (display "#! /bin/sh" port)
      (newline port)
      (newline port)
      (display "export MIYKA_PID_SYNC=$$" port)
      (newline port)
      (display "export MIYKA_PID_ASYNC=1" port)
      (newline port)
      (newline port)

      (for-each
       (lambda (line) (display line port) (newline port))
       (reverse
        (stack->list sync-footer)))))

  (unless (stack-empty? async-footer)
    (call-with-output-file
        run-async-script-path
      (lambda (port)
        (display "#! /bin/sh" port)
        (newline port)
        (newline port)
        (display "export MIYKA_PID_ASYNC=$$" port)
        (newline port)
        (newline port)

        (for-each
         (lambda (line) (display line port) (newline port))
         (reverse
          (stack->list async-footer))))))

  (call-with-output-file
      manifest-path
    (lambda (port)
      (write
       `(specifications->manifest
         (quote ,packages))
       port)))

  (call-with-output-file
      run-script-path
    (lambda (port)
      (define NL "\\\n")

      (fprintf
       port
       run-script:template

       (words->string
        (list
         "\"$MIYKA_GUIX_EXECUTABLE\"" NL
         "shell" maybe-pure NL
         "--manifest=manifest.scm" NL
         "--" NL
         "/bin/sh" "\"$PWD/enter.sh\"" NL
         maybe-move-home "--guix-executable" "\"$MIYKA_GUIX_EXECUTABLE\"" NL
         "--" NL
         "sh" "--" "\"$PWD/run-sync.sh\""
         )))

      (newline port)))

  (system*/exit-code "/bin/sh" "--" run-script-path))
