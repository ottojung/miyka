;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define (CLI:import-id <id> <name> <new-name>)
  (define fetcher
    (get-fetcher))

  ;; FIXME: remove this after everything is done.
  (define destination
    (make-temporary-filename))

  (define _71273
    (when (file-or-directory-exists? destination)
      (raisu-fmt
       'trying-to-fetch-existing-repository
       "Trying to fetch a repository that already exists.")))

  (define script
    (stringf "
export MIYKA_FETCHER_ARG_ID=~s
export MIYKA_FETCHER_ARG_NAME=~s
export MIYKA_FETCHER_ARG_DESTINATION=~s
exec /bin/sh -- ~s
"
             (~a (or <id> ""))
             (~a (or <name> ""))
             (~a destination)
             (~a fetcher)))

  ;; TODO: generate an actual script.
  (define exit-code
    (system*/exit-code
     "/bin/sh" "-c" script))

  (unless (= 0 exit-code)
    (raisu-fmt
     'fetcher-failed/status
     "Fetcher failed to fetch the repository."))

  (unless (file-or-directory-exists? destination)
    (raisu-fmt
     'fetcher-failed/result
     "Fetcher failed to fetch the repository."))

  (CLI:import-directory destination <new-name>))
