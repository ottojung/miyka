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

  (define teardown-command-list
    (stack-make))

  (define sync-footer
    (stack-make))

  (define cleanup-command
    (stringf "test -f ~s && MIYKA_PROC_ID=$MIYKA_PID_SYNC sh -- ~s" cleanup cleanup))

  (define cleanup-wrapper
    (let ()
      (define base "
rm -rf -- \"$MIYKA_WORK_PATH/temporary\"
mkdir -p -- \"$MIYKA_WORK_PATH/temporary\"
")
      (if cleanup
          (stringf "~a\n~a" base cleanup-command)
          base)))

  (define guix-describe-command
    "\"$MIYKA_GUIX_EXECUTABLE\" describe --format=channels > \"$MIYKA_WORK_PATH/state/channels.scm\"")

  (define snapshot-command
    "
#########################
# Snapshot with Restic. #
#########################

MIYKA_REPO_ID=\"$(cat -- \"$MIYKA_WORK_PATH/id.txt\")\"
MIYKA_GLOBAL_ID_PATH=\"$MIYKA_ROOT/globalid\"
HOSTNAME=\"$(cat -- '/etc/hostname')\"

cd -- \"$MIYKA_ROOT\"

if ! test -e ./backups
then
    restic init --quiet --repo ./backups --password-command 'echo 1234'
fi

if ! test -f \"$MIYKA_GLOBAL_ID_PATH\"
then
    cat -- '/dev/urandom' | base32 | head -c 16  > \"$MIYKA_GLOBAL_ID_PATH\"
fi

MIYKA_GLOBAL_ID=\"$(cat -- \"$MIYKA_GLOBAL_ID_PATH\")\"

if ! restic backup --quiet --repo ./backups --password-command 'echo 1234' --tag id:\"$MIYKA_REPO_ID\" --tag time:$(date +%s) --tag action:exit --tag hostname:\"$HOSTNAME\" --tag globalid:\"$MIYKA_GLOBAL_ID\" -- \"repositories/$MIYKA_REPO_ID/wd\"
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
    /bin/sh -- \"$MIYKA_WORK_PATH/state/setup.sh\" \\
    \"$MIYKA_REPO_HOME\" \"$MIYKA_WORK_PATH\" \"$MIYKA_ORIG_HOME\" \"$MIYKA_REPO_PATH\" \"$MIYKA_ROOT\" \"$MIYKA_GUIX_EXECUTABLE\" \"$MIYKA_PID_SYNC\"
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

if ! HOME=\"$MIYKA_ORIG_HOME\" \"$MIYKA_GUIX_EXECUTABLE\" shell \\
    --pure \\
    coreutils grep findutils procps sed gawk nss-certs restic git make openssh gnupg \\
    -- \\
    /bin/sh -- \"$MIYKA_WORK_PATH/state/teardown.sh\" \\
    \"$MIYKA_REPO_HOME\" \"$MIYKA_WORK_PATH\" \"$MIYKA_ORIG_HOME\" \"$MIYKA_REPO_PATH\" \"$MIYKA_ROOT\" \"$MIYKA_GUIX_EXECUTABLE\" \"$MIYKA_PID_SYNC\"
then
    echo 'Teardown script failed.' 1>&2
fi

trap '' exit hup int quit abrt kill alrm term

}

trap 'teardown' exit hup int quit abrt kill alrm term

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

    LINK_VALUE=\"$(echo | awk -v first_path=\"home/u/$LOCATION/..\" -v second_path=\"temporary/miyka-orig-home/$LOCATION\" -f \"$MIYKA_WORK_PATH/state/relative-path.awk\")\"
    ln -svT -- \"$LINK_VALUE\" \"$MIYKA_REPO_HOME/$LOCATION\"   1>&2
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

  (stack-push! sync-footer cleanup-wrapper)

  (unless (stack-empty? setup-command-list)
    (stack-push! sync-footer setup-command))

  (stack-push! sync-footer teardown-command)

  (for-each
   (lambda (command)
     (cond
      ((command:shell? command)
       (stack-push!
        sync-footer
        (stringf "MIYKA_PROC_ID=$MIYKA_PID_SYNC sh -- ~s" (command:shell:path command))))

      (else
       (raisu* :from "interpretation:run!"
               :type 'unknown-command
               :message (stringf "Uknown command ~s." command)
               :args (list command)))))
   commands)

  (stack-push!
   teardown-command-list
   "
 ############################
 # Kill dangling processes. #
 ############################

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

")

  (stack-push!
   teardown-command-list
   cleanup-wrapper)

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

    (make-directories dirpath)
    (call-with-output-file
        path
      (lambda (port)
        (fprintf port enter-script:template))))

  (call-with-output-file
      relative-path-script-path
    (lambda (port)
      (display relative-path-script:template port)))

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
        (display "export MIYKA_WORK_PATH=\"$2\"" port)
        (newline port)
        (display "export MIYKA_ORIG_HOME=\"$3\"" port)
        (newline port)
        (display "export MIYKA_REPO_PATH=\"$4\"" port)
        (newline port)
        (display "export MIYKA_ROOT=\"$5\"" port)
        (newline port)
        (display "export MIYKA_GUIX_EXECUTABLE=\"$6\"" port)
        (newline port)
        (display "export MIYKA_PID_SYNC=\"$7\"" port)
        (newline port)
        (display "export PATH=\"$PATH:$MIYKA_WORK_PATH/bin\"" port)
        (newline port)
        (newline port)

        (for-each
         (lambda (line) (display line port) (newline port) (newline port))
         (reverse
          (stack->list setup-command-list))))))

  (unless (stack-empty? teardown-command-list)
    (call-with-output-file
        teardown-script-path
      (lambda (port)
        (display "#! /bin/sh" port)
        (newline port)
        (newline port)

        (display "export MIYKA_REPO_HOME=\"$1\"" port)
        (newline port)
        (display "export MIYKA_WORK_PATH=\"$2\"" port)
        (newline port)
        (display "export MIYKA_ORIG_HOME=\"$3\"" port)
        (newline port)
        (display "export MIYKA_REPO_PATH=\"$4\"" port)
        (newline port)
        (display "export MIYKA_ROOT=\"$5\"" port)
        (newline port)
        (display "export MIYKA_GUIX_EXECUTABLE=\"$6\"" port)
        (newline port)
        (display "export MIYKA_PID_SYNC=\"$7\"" port)
        (newline port)
        (display "export PATH=\"$PATH:$MIYKA_WORK_PATH/bin\"" port)
        (newline port)
        (newline port)

        (for-each
         (lambda (line) (display line port) (newline port) (newline port))
         (reverse
          (stack->list teardown-command-list))))))

  (call-with-output-file
      run-sync-script-path
    (lambda (port)
      (display "#! /bin/sh" port)
      (newline port)
      (newline port)
      (display "export MIYKA_PID_SYNC=$$" port)
      (newline port)
      (newline port)

      (for-each
       (lambda (line) (display line port) (newline port))
       (reverse
        (stack->list sync-footer)))))

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
         "--miyka-root" "\"$MIYKA_ROOT\"" NL
         "--" NL
         "sh" "--" "\"$PWD/run-sync.sh\""
         )))

      (newline port)))

  (system*/exit-code "/bin/sh" "--" run-script-path))
