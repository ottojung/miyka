;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define (CLI:copy <existing-repository-name> <new-repository-name>)
  (check-if-repository-already-exists <new-repository-name>)

  (initialize-repository <new-repository-name>)

  (let ()
    (define guix
      (get-guix-executable))
    (define existing-configuration
      (repository:configuration <existing-repository-name>))
    (define existing-configuration-path
      (configuration:path existing-configuration))
    (define new-configuration
      (repository:configuration <new-repository-name>))
    (define new-configuration-path
      (configuration:path new-configuration))

    (make-directories (path-get-dirname new-configuration-path))
    (system*/exit-code
     guix "shell" "--pure" "coreutils"
     "--"
     "cp" "-r" "-T"
     "--"
     existing-configuration-path
     new-configuration-path
     ))

  (values))
