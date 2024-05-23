;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define (interpretation:run! repository interpretation)
  (define repo-path
    (repository:path repository))
  (define manifest
    (repository:manifest repository))
  (define manifest-path
    (manifest:path manifest))
  (define script
    (repository:start-script repository))
  (define script-path
    (start-script:path script))
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

  (define (make-start-script script-path footer)
    (call-with-output-file
        script-path
      (lambda (port)
        (define home-line
          (if home-moved?
              "export HOME=\"$MIYKA_REPO_HOME\""
              ""))
        (fprintf
         port
         start-script:template
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

  (define shell-args
    (list "dash" "--" script-path repository repo-path))

  (define default-guix-args
    (list "guix" "shell" (string-append "--manifest=" manifest-path)))

  (define run-args
    (cond
     ((and (not pure?) (null? packages))
      shell-args)

     ((and (not pure?) (pair? packages))
      (append default-guix-args (list "--") shell-args))

     (else
      (append default-guix-args (list "--pure") (list "--") shell-args))))

  (define sync-footer
    (stack-make))

  (define async-footer
    (stack-make))

  (define current-footer
    sync-footer)

  (for-each
   (lambda (command)
     (cond
      ((command:detach? command)
       (set! current-footer async-footer))

      ((command:shell? command)
       (stack-push!
        current-footer
        (stringf "dash -l -i -- ~s" (command:shell:path command))))

      (else
       (raisu* :from "interpretation:run!"
               :type 'unknown-command
               :message (stringf "Uknown command ~s." command)
               :args (list command)))))
   commands)

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
test -f ~s && dash -l -- ~s
exit $RETURN_CODE" cleanup cleanup))))

  (unless (stack-empty? async-footer)
    (let ()
      (define async-script
        (repository:async-script repository))
      (define path
        (async-script:path async-script))

      (stack-push!
       sync-footer
       (stringf "{ dash -l -- ~s & } &" path))

      (call-with-output-file
          path
        (lambda (port)
          (define footer
            (lines->string
             (reverse
              (stack->list async-footer))))
          (display footer port)))))

  (let ()
    (define footer
      (lines->string
       (reverse
        (stack->list sync-footer))))

    (make-start-script
     script-path footer))

  (call-with-output-file
      manifest-path
    (lambda (port)
      (write
       `(specifications->manifest
         (quote ,packages))
       port)))

  (when cleanup
    (make-start-script
     wrapper-path
     (stringf "test -f ~s && dash -l -- ~s"
              cleanup cleanup))
    (system*/exit-code "dash" "--" wrapper-path repository repo-path))

  (when snapshot?
    (save-repository-context repository))

  (apply system*/exit-code run-args))
