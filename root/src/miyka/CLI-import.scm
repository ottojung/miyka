;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define (CLI:import path-to-repository <optional-name>)
  (define guix (get-guix-executable))
  (define name
    (or <optional-name>
        (path-get-basename path-to-repository)))

  (define target-path
    (repository:path name))

  (check-if-repository-already-exists name)

  (unless (= 0 (system*/exit-code
                guix "shell" "--pure" "coreutils"
                "--" "mv" "-T" "--" path-to-repository target-path
                ))
    (raisu-fmt 'import-command-failed
               "Failed to move the imported files into Miyka's root."))

  (unless (= 0 (system*/exit-code
                guix "shell" "--pure" "coreutils"
                "--" "ln" "-srf" "--" target-path path-to-repository
                ))

    (raisu-fmt 'import-command-failed
               "Failed to symlink the imported repository to the original path. The repository has been moved to ~s."
               target-path))

  (values))
