;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define (snapshot-repository-files repository)
  (define wd
    (repository:state-directory repository))
  (define wd-path
    (state-directory:path wd))
  (define log-directory
    (repository:log-directory repository))
  (define log-directory-path
    (log-directory:path log-directory))

  (unless (= 0 (system*/exit-code
                "restic"
                "backup"
                "--quiet"
                "--repo" log-directory-path
                "--password-command" "echo 1234"
                wd-path))
    (raisu-fmt
     'snapshot-command-failed
     "Command restic backup failed. Cannot create a log because of this.")))
