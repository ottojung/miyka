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
  (define packages
    (interpretation:installist interpretation))

  (define commands
    (reverse
     (stack->list
      (interpretation:commands interpretation))))

  (define home-moved?
    (box-ref
     (interpretation:home-moved? interpretation)))

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
        (stringf "dash -i -- ~s" (command:shell:path command))))

      (else
       (raisu* :from "interpretation:run!"
               :type 'unknown-command
               :message (stringf "Uknown command ~s." command)
               :args (list command)))))
   commands)

  (unless (stack-empty? async-footer)
    (let ()
      (define async-script
        (repository:async-script repository))
      (define path
        (async-script:path async-script))

      (stack-push!
       sync-footer
       (stringf "{ dash -- ~s & } &" path))

      (call-with-output-file
          path
        (lambda (port)
          (define footer
            (lines->string
             (reverse
              (stack->list async-footer))))
          (fprintf port footer)))))

  (call-with-output-file
      script-path
    (lambda (port)
      (define footer
        (lines->string
         (reverse
          (stack->list sync-footer))))
      (define home-line
        (if home-moved?
            "export HOME=\"$MIYKA_REPO_PATH/wd/home\""
            ""))
      (fprintf
       port
       start-script:template
       home-line
       footer)))

  (call-with-output-file
      manifest-path
    (lambda (port)
      (write
       `(specifications->manifest
         (quote ,packages))
       port)))

  (system*/exit-code
   "guix" "shell"
   "--pure"
   (string-append "--manifest=" manifest-path)
   "--" "dash" "--" script-path repository repo-path
   ))
