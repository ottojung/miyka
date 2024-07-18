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
    /         edit ID
    /         run ID
    /         list
    /         copy ID as <new-name>
    /         remove ID
    /         import directory <path> as <new-name>
    /         import ID as <new-name>
    /         get GET_ARGUMENTS
    GET_ARGUMENTS : home of ID
    /               config-path of ID
    /               root-path of ID
    /               id of <name>
    /               name of id <id>
    ID       : id <id>
    /          <name>
    OPT : --root <root>
    /     --guix-executable <guix-executable>
    /     --fetcher <fetcher>
    )

   :default (<root> (get-root/default))
   :default (<guix-executable> (get-guix-executable/default))
   :default (<fetcher> (get-fetcher/default))

   (parameterize ((root/p <root>)
                  (guix-executable/p <guix-executable>)
                  (fetcher/p <fetcher>)
                  )

     (define repository (repository:make))
     (define fetcher (get-fetcher/default))

     (when <name>
       (set-property!
        (repository:name repository)
        <name>))

     (when <id>
       (let ((x (repository:id repository)))
         (set-property!
          (id:value x)
          <id>)))

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
       (CLI:copy repository <new-name>))

      (remove
       (CLI:remove repository))

      ((and import directory)
       (CLI:import-directory <path> <new-name>))

      ((or (and import id <id>)
           (and import <name>))
       (CLI:import-id <id> <name> <new-name>))

      ((and get home of)
       (CLI:get-repository-home repository))

      ((and get config-path of)
       (CLI:get-config-path repository))

      ((and get root-path of)
       (CLI:get-root-path repository))

      ((and get name of)
       (CLI:get-name repository))

      ((and get id of)
       (CLI:get-id repository))

      ))))

(with-user-errors
 :types (list
         'unknown-root
         'unknown-fetcher
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
         'fetcher-path-must-be-absolute
         'guix-path-must-be-absolute
         )

 (with-properties
  :for-everything
  (with-randomizer-seed
   :random
   (main))))
