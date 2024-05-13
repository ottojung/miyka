;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define (save-repository-context repository)
  (define repo-path
    (repository:path repository))
  (define log-directory
    (repository:log-directory repository))
  (define log-directory-path
    (log-directory:path log-directory))
  (define date
    (date-get-current-string "~Y-~m-~dT~H-~M-~S-~N-~Z"))
  (define current-directory-path
    (append-posix-path log-directory-path date))
  (define manifest
    (repository:manifest repository))
  (define manifest-path
    (manifest:path manifest))

  (define target-manifest-path
    (append-posix-path
     current-directory-path
     (path-get-basename manifest)))

  (define channels-path
    (append-posix-path current-directory-path "channels.scm"))

  (make-directories current-directory-path)
  (file-copy manifest-path target-manifest-path)
  (guix-describe channels-path)

  (values))
