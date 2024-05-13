;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define (main)
  (with-cli
   (MAIN
    MAIN : OPT* COMMAND
    /      --help
    /      --version
    COMMAND : create <name>
    /         edit <name>
    /         run <name>
    OPT : --root <root>
    )

   :default (<root> (get-root/default))

   (parameterize ((root/p <root>))

     (cond

      (--help
       (with-ignore-errors!
        (define-cli:show-help)))

      (--version
       (display "0.0.1")
       (newline))

      (create
       (CLI:create <name>))

      (edit
       (CLI:edit <name>))

      (run
       (CLI:run <name>))

      ))))

(with-user-errors
 :types (list
         'unknown-root
         'repo-already-exists
         'empty-repo-name
         'repository-does-not-exist
         'editor-not-defined
         'editor-failed
         )

 (with-properties
  :for-everything
  (main)))
