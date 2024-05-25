;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define configuration:template
  "

(cleanup \".config/miyka/cleanup.sh\")
(snapshot)

;; (impure)

(install \"coreutils\") ;; basic POSIX utils.
(install \"nvi\")       ;; a POSIX vi editor.
(install \"findutils\") ;; a POSIX vi editor.
(install \"sed\")       ;; a POSIX sed program.
(install \"gawk\")      ;; a POSIX awk program.
(install \"less\")      ;; a pager program.
(install \"nss-certs\") ;; HTTPS certificates.

(host \".cache\")                   ;; symlink .cache/ directory from the host's user home, to workspace's home.
(host \".local/share/Trash\")       ;; same with the Trash directory.

(move-home)             ;; set $HOME env variable to the location of the workspace.

;; (detach)
(shell \".config/miyka/init.sh\")

")
