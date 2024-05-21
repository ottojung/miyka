;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define-property repository:cleanup-wrapper)

(define-provider p
  :targets (repository:cleanup-wrapper)
  :sources (repository:state-directory)
  (lambda (this)
    (define state (repository:state-directory this))
    (define state-path (state-directory:path state))
    (append-posix-path state-path "cleanup-wrapper.sh")))
