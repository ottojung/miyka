;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define (get-repositories-id-map)
  (define path (get-repositories-id-map-path))

  (unless (file-or-directory-exists? path)
    (raisu-fmt
     'missing-repositories-id-map
     "Repositories id map at ~a does not exist."
     (~a path)))

  (let ()
    (define csv (parse-csv-file path))

    (define associative-list
      (map
       (lambda (table)
         (cons
          (assoc-or 'id table
                    (raisu* :from "get-repositories-id-map"
                            :type 'missing-id
                            :message (stringf "Table entry ~s does not have the ~s field." table (~a 'id))
                            :args (list table csv path)))

          (assoc-or 'name table
                    (raisu* :from "get-repositories-id-map"
                            :type 'missing-name
                            :message (stringf "Table entry ~s does not have the ~s field." table (~a 'name))
                            :args (list table csv path)))))
       csv))

    associative-list))
