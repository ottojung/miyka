;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define ROOT_VAR_NAME "MIYKA_ROOT")

(define get-root/env
  (memconst
   (or (system-environment-get ROOT_VAR_NAME)
       (let ((home (system-environment-get "XDG_DATA_HOME")))
         (and home (append-posix-path home "miyka" "root")))
       (let ((home (system-environment-get "HOME")))
         (and home (append-posix-path home ".local" "share" "miyka" "root"))))))

(define get-root/default
  (let ((root-made? #f))
    (lambda _
      (define root0
        (or (root/p) (get-root/env)))
      (define root
        (and root0
             (if (absolute-posix-path? root0) root0
                 (append-posix-path (get-current-directory) root0))))

      root)))

(define (get-root)
  (or (get-root/default)
      (raisu 'unknown-root
             (stringf "Root is unknown because $~a env variable is not defined." ROOT_VAR_NAME))))
