;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define (CLI:edit repository)
  (unless (repository:exists-on-disk? repository)
    (raisu-fmt 'repository-does-not-exist
               "Repository named ~s does not exist."
               (repository:name repository)))

  (let ()
    (define editor
      (get-current-editor))

    (define configuration
      (repository:configuration repository))

    (define path
      (configuration:path configuration))

    (touch-file path)

    (let ()
      (define result
        (system*/exit-code editor path))

      (unless (= 0 result)
        (raisu-fmt
         'editor-failed
         "Editor process exited with error.")))))
