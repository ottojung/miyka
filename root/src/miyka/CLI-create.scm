;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define (CLI:create repository)

  (check-if-repository-already-exists repository)
  (make-directories (repository:path repository))

  (let ()
    (define log-directory
      (repository:log-directory repository))
    (define log-directory-path
      (log-directory:path log-directory))

    (unless (= 0 (system*/exit-code
                  "restic"
                  "init"
                  "--quiet"
                  "--repo" log-directory-path
                  "--password-command" "echo 1234"))
      (raisu-fmt
       'snapshot-init-command-failed
       "Command restic init failed. Cannot create a log because of this.")))

  (let ()
    (define wd (repository:work-directory repository))
    (define wd-path (work-directory:path wd))
    (make-directories wd-path))

  (let ()
    (define script
      (repository:start-script repository))
    (define path
      (start-script:path script))

    (call-with-output-file
        path
      (lambda (port)
        (display start-script:template port))))

  (let ()
    (define script
      (repository:init-script repository))
    (define path
      (init-script:path script))
    (define dirpath
      (path-get-dirname path))

    (make-directories dirpath)
    (call-with-output-file
        path
      (lambda (port)
        (display init-script:template port))))

  (let ()
    (define configuration
      (repository:configuration repository))
    (define path
      (configuration:path configuration))

    (call-with-output-file
        path
      (lambda (port)
        (display configuration:template port))))

  (values))
