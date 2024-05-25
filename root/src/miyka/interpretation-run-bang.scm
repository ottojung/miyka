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
    (stringf "test -f ~s && sh -- ~s" cleanup cleanup))

  (define guix-describe-command
    "\"$MIYKA_GUIX_EXECUTABLE\" describe --format=channels > .config/miyka/channels.scm")

  (define snapshot-command
    "restic backup --quiet --repo \"$MIYKA_REPO_PATH\"/logs --password-file .config/miyka/password.txt -- \"$MIYKA_REPO_PATH\"/wd")

  (define setup-command
    "\"$MIYKA_GUIX_EXECUTABLE\" shell --pure restic coreutils -- /bin/sh .config/miyka/setup.sh \"$MIYKA_REPO_HOME\" \"$MIYKA_REPO_PATH\" \"$MIYKA_ORIG_HOME\" \"$MIYKA_GUIX_EXECUTABLE\"")

  (when snapshot?
    (stack-push! setup-command-list snapshot-command))

  (stack-push! setup-command-list guix-describe-command)

  (when cleanup
    (stack-push! sync-footer cleanup-command))

  (stack-push! sync-footer setup-command)

  (for-each

   (lambda (path)
     (stack-push!
      setup-command-list
      (stringf "
if ! test -e \"$MIYKA_REPO_HOME\"/~s
then
    if test -e \"$MIYKA_ORIG_HOME\"/~s
    then
        ln -srT -- \"$MIYKA_ORIG_HOME\"/~s \"$MIYKA_REPO_HOME\"/~s
    fi
fi
" path path path path)))

   host-locations)

  (for-each
   (lambda (command)
     (cond
      ((command:detach? command)
       (set! current-footer async-footer))

      ((command:shell? command)
       (stack-push!
        current-footer
        (stringf "sh -- ~s" (command:shell:path command))))

      (else
       (raisu* :from "interpretation:run!"
               :type 'unknown-command
               :message (stringf "Uknown command ~s." command)
               :args (list command)))))
   commands)

  (unless (stack-empty? async-footer)
    (stack-push!
     sync-footer
     "{ sh -- .config/miyka/run-async.sh & } &"))

  (when cleanup
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
       (stringf "RETURN_CODE=$?
~a
exit $RETURN_CODE" cleanup-command))))

  (call-with-output-file
      setup-script-path
    (lambda (port)
      (display "#! /bin/sh" port)
      (newline port)
      (newline port)

      (display "MIYKA_REPO_HOME=\"$1\"" port)
      (newline port)
      (display "MIYKA_REPO_PATH=\"$2\"" port)
      (newline port)
      (display "MIYKA_ORIG_HOME=\"$3\"" port)
      (newline port)
      (display "MIYKA_GUIX_EXECUTABLE=\"$4\"" port)
      (newline port)
      (newline port)

      (for-each
       (lambda (line) (display line port) (newline port) (newline port))
       (reverse
        (stack->list setup-command-list)))))

  (call-with-output-file
      run-sync-script-path
    (lambda (port)
      (display "#! /bin/sh" port)
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
      (fprintf
       port
       run-script:template

       (words->string
        (list
         "\"$MIYKA_GUIX_EXECUTABLE\""
         "shell"
         maybe-pure
         "--manifest=manifest.scm"
         "--"
         "/bin/sh" "\"$PWD/enter.sh\""
         maybe-move-home
         "--guix-executable" "\"$MIYKA_GUIX_EXECUTABLE\""
         "--"
         "sh" ".config/miyka/run-sync.sh"
         )))))

  (system*/exit-code "/bin/sh" "--" run-script-path))
