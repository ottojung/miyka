;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define (CLI:import path-to-repository name)
  (define guix (get-guix-executable))
  (define repository (repository:make))

  (set-property! (repository:name repository) name)

  (let ()
    (with-properties
     :for-everything
     (let ()
       (check-if-repository-already-exists repository)
       (set-property! (repository:path repository) path-to-repository)
       (let ()
         (define id (repository:id repository))
         (define id-path (id:path id))
         (define id-value
           (begin
             (unless (file-or-directory-exists? id-path)
               (raisu-fmt
                'imported-repository-does-not-have-id
                (stringf "Imported repository at ~s does not have an id file at ~s."
                         path-to-repository
                         id-path)))

             (~a (call-with-input-file id-path read))))

         (set-property! (id:value id) id-value)
         (register-repository-name repository))))

    (let ()
      (define target-path (repository:path repository))

      (unless (= 0 (system*/exit-code
                    guix "shell" "--pure" "coreutils"
                    "--" "mv" "-T" "--" path-to-repository target-path
                    ))
        (raisu-fmt 'import-command-failed
                   "Failed to move the imported files into Miyka's root."))

      (unless (= 0 (system*/exit-code
                    guix "shell" "--pure" "coreutils"
                    "--" "ln" "-sfT" "--" target-path path-to-repository
                    ))
        (raisu-fmt 'import-command-failed
                   "Failed to symlink the imported repository to the original path. The repository has been moved to ~s."
                   target-path))

      ))

  (values))
