;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define-property repository:home)

(define-provider p
  :targets (repository:home)
  :sources (repository:work-directory)
  (lambda (this)
    (define wd (repository:work-directory this))
    (define wd-path (work-directory:path wd))
    (append-posix-path wd-path "home" "u")))
