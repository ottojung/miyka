;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define (language:start)
  (define repository
    (current-repository/p))
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
    (reverse (stack->list (install-list/p))))

  (call-with-output-file
      manifest-path
    (lambda (port)
      (write
       `(specifications->manifest
         (quote ,packages))
       port)))

  (let ()

    (define result
      (system*/exit-code
       "guix" "shell"
       "--pure"
       (string-append "--manifest=" manifest-path)
       "--" "/bin/sh" "-i" "--" script-path repository repo-path
       ))

    (values)))
