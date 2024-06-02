;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define (initialize-repository repository)
  (make-directories (repository:path repository))

  (let ()
    (define wd (repository:state-directory repository))
    (define wd-path (state-directory:path wd))
    (make-directories wd-path))

  (let ()
    (define home (repository:home repository))
    (define home-path (home:path home))
    (make-directories home-path))

  (let ()
    (define bin (repository:bin repository))
    (define bin-path (bin:path bin))
    (define guix (get-guix-executable))
    (make-directories bin-path)

    (unless (= 0 (system*/exit-code
                  guix "shell" "--pure" "coreutils"
                  "--" "ln" "-s" "-T" "--" "/bin/sh" (append-posix-path bin-path "sh")
                  ))
      (raisu-fmt 'link-command-failed
                 "Failed to link /bin/sh to miyka's repository root. The \"sh\" executable will not be available because of this.")))

  (let ()
    (define id (repository:id repository))
    (define id-path (id:path id))
    (make-directories (path-get-dirname id-path))
    (call-with-output-file
        id-path
      (lambda (port)
        (display (random-variable-name 16) port))))

  (values))
