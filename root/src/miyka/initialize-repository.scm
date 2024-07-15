;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define (initialize-repository repository)
  (define id (repository:id repository))
  (define id-value (random-variable-name 16))
  (set-property! (id:value id) id-value)

  (register-repository-name repository)
  (make-directories (repository:path repository))

  (let ()
    (define id (repository:id repository))
    (define id-path (id:path id))
    (make-directories (path-get-dirname id-path))
    (call-with-output-file/lazy
        id-path
      (lambda (port)
        (display id-value port))))

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
    (define target (append-posix-path bin-path "sh"))
    (make-directories bin-path)

    (unless (file-or-directory-exists? target)
      (unless (= 0 (system*/exit-code
                    guix "shell" "--pure" "coreutils"
                    "--" "ln" "-s" "-T" "--" "/bin/sh" target
                    ))
        (raisu-fmt 'link-command-failed
                   "Failed to link /bin/sh to miyka's repository root. The \"sh\" executable will not be available because of this."))))

  (values))
