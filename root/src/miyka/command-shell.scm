;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define-type9 command:shell
  (command:shell:constructor
   path
   )

  command:shell:raw?

  (path command:shell:path:raw)
  )

(define (command:shell? object)
  (and (command? object)
       (command:shell:raw? (command:object object))))

(define (command:shell:make path)
  (command:make
   (command:shell:constructor path)))

(define (command:shell:path command)
  (command:shell:path:raw
   (command:object command)))
