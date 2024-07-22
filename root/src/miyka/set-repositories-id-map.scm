;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define (set-repositories-id-map id-map)
  (define path (get-repositories-id-map-path))
  (call-with-output-file/lazy
   path
   (lambda (port)
     (display "id,name" port)
     (newline port)

     (for-each
      (lambda (p)
        (define-pair (id name) p)
        (display id port)
        (display "," port)
        (display name port)
        (newline port))
      id-map))))
