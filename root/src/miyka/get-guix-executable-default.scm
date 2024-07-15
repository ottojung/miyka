;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define get-guix-executable/default
  (memconst
   (or (system-environment-get guix-executable-env-variable-name)
       (let ()
         (define-pair (re status)
           (system-re "INITIAL=\"$(command -v guix 2>/dev/null)\" ; if test -z \"$INITIAL\" ; then exit 1 ; else realpath -- \"$INITIAL\" ; if ! test \"$?\" = 0 ; then printf '%s' \"$INITIAL\" ; fi ; fi"))

         (and (= 0 status)
              (string-strip re))))))
