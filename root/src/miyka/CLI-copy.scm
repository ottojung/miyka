;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define (CLI:copy <existing-repository-name> <new-repository-name>)
  (check-if-repository-already-exists <new-repository-name>)

  (initialize-repository <new-repository-name>)

  (let ()
    (define guix
      (get-guix-executable))
    (define existing-state
      (repository:state-directory <existing-repository-name>))
    (define existing-state-path
      (state-directory:path existing-state))
    (define new-state
      (repository:state-directory <new-repository-name>))
    (define new-state-path
      (state-directory:path new-state))

    (make-directories (path-get-dirname new-state-path))
    (system*/exit-code
     guix "shell" "--pure" "coreutils"
     "--"
     "cp" "-r" "-T"
     "--"
     existing-state-path
     new-state-path
     ))

  (values))
