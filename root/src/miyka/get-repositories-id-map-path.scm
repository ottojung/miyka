;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define get-repositories-id-map-path
  (memconst
   (let ()
     (define root (get-root))
     (define result (append-posix-path root "id-map.toml"))

     (unless (file-or-directory-exists? result)
       (make-directories root)
       (call-with-output-file/lazy
           result
         (lambda (port)
           (write '() port))))

     result)))
