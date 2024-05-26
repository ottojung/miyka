;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define (restic-password-file:generate output)
  (define guix (get-guix-executable))
  (system*/exit-code
   guix "shell" "--pure" "coreutils"
   "--"
   "/bin/sh" "-c"
   (stringf "cat /dev/urandom 2>/dev/null | base64 2>/dev/null | head -c 20 > ~s" output)))
