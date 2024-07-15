;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define (main)
  (assert= providers #t)

  (with-cli
   (MAIN
    MAIN : OPT* COMMAND
    /      --help
    /      --version
    COMMAND : create <name>
    /         edit <name>
    /         run <name>
    /         list
    /         copy <existing-name> as <new-name>
    /         remove <name>
    /         import <path> as <name>
    /         get GET_ARGUMENTS
    GET_ARGUMENTS : home of <name>
    /               config-path of <name>
    /               root-path of <name>
    OPT : --root <root>
    /     --guix-executable <guix-executable>
    )

   :default (<root> (get-root/default))
   :default (<guix-executable> (get-guix-executable/default))

   (parameterize ((root/p <root>)
                  (guix-executable/p <guix-executable>)
                  )

     (define repository (make-unique))

     (when <name>
       (set-property!
        (repository:name repository)
        <name>))

     (cond

      (--help
       (with-ignore-errors!
        (define-cli:show-help)))

      (--version
       (display miyka:version)
       (newline))

      (create
       (CLI:create repository))

      (edit
       (CLI:edit repository))

      (run
       (CLI:run repository))

      (list
       (CLI:list))

      (copy
       (CLI:copy <existing-name> <new-name>))

      (remove
       (CLI:remove repository))

      (import
       (CLI:import <path> repository))

      ((and get home of)
       (CLI:get-repository-home repository))

      ((and get config-path of)
       (CLI:get-config-path repository))

      ((and get root-path of)
       (CLI:get-root-path repository))

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
         'imported-repository-does-not-have-id
         )

 (with-properties
  :for-everything
  (with-randomizer-seed
   :random
   (main))))
