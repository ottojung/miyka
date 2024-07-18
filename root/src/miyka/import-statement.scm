;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define-type9 <directory-import-statement>
  (directory-import-statement:make path new-name) directory-import-statement?
  (path directory-import-statement:path)
  (new-name directory-import-statement:new-name)
  )

(define-type9 <id-import-statement>
  (id-import-statement:make value new-name) id-import-statement?
  (value id-import-statement:value)
  (new-name id-import-statement:new-name)
  )

(define-type9 <name-import-statement>
  (name-import-statement:make value new-name) name-import-statement?
  (value name-import-statement:value)
  (new-name name-import-statement:new-name)
  )

(define (import-statement? obj)
  (or (directory-import-statement? obj)
      (id-import-statement? obj)
      (name-import-statement? obj)
      #f))
