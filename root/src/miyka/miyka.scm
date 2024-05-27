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
    /         list
    /         copy <existing-name> <new-name>
    /         remove <name>
    /         import IMPORT_OPTS
    IMPORT_OPTS : --name <optional-name> <path>
    /         <path>
    OPT : --root <root>
    /     --guix-executable <guix-executable>
    )

   :default (<root> (get-root/default))
   :default (<guix-executable> (get-guix-executable/default))

   (parameterize ((root/p <root>)
                  (guix-executable/p <guix-executable>)
                  )

     (cond

      (--help
       (with-ignore-errors!
        (define-cli:show-help)))

      (--version
       (display "1.4.1")
       (newline))

      (create
       (CLI:create <name>))

      (edit
       (CLI:edit <name>))

      (run
       (CLI:run <name>))

      (list
       (CLI:list))

      (copy
       (CLI:copy <existing-name> <new-name>))

      (remove
       (CLI:remove <name>))

      (import
       (CLI:import <path> <optional-name>))

      ))))

(with-user-errors
 :types (list
         'unknown-root
         'repo-already-exists
         'empty-repo-name
         'repository-does-not-exist
         'editor-not-defined
         'editor-failed
         'guix-describe-failed
         'snapshot-command-failed
         'snapshot-init-command-failed
         'import-command-failed
         'link-command-failed
         'cannot-find-guix
         )

 (with-properties
  :for-everything
  (main)))
