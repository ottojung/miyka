;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define configuration:template
  "
(cleanup \".config/miyka/cleanup.sh\") ;; Execute the cleanup script before and after all shell scripts.

(snapshot)              ;; Save a snapshot of the entire workspace efficiently.

;; Uncomment to use both host's and workspace's packages.
;; (impure)

;; Specify packages to be installed within the workspace environment.
(install \"coreutils\") ;; Install basic POSIX utilities.
(install \"nvi\")       ;; Install the POSIX editor \"vi\".
(install \"findutils\") ;; Install the POSIX \"find\" utility.
(install \"sed\")       ;; Install the POSIX \"sed\" stream editor.
(install \"gawk\")      ;; Install the POSIX \"awk\" programming language.
(install \"less\")      ;; Install \"less\", a terminal pager program.
(install \"procps\")    ;; Install \"ps\", \"top\", \"pkill\", \"watch\", and several other common utils.
(install \"nss-certs\") ;; Install HTTPS certificates.
(install \"ncurses\")   ;; Install \"ncurses\" which provides \"clear\" and \"reset\" commands, essential for terminal management.

;; Symlink specific directories and files from the host user's home to the workspace home.
(host \".cache/\")                   ;; Symlink the .cache/ directory.
(host \".local/share/Trash/\")       ;; Symlink the Trash directory.
(host \".Xresources\")               ;; Symlink the .Xresources file for X color scheme.
(host \".Xdefaults\")                ;; Symlink the .Xdefaults file for X color scheme.
                                     ;; Note: The trailing \"/\" indicates that a directory is being linked.
                                     ;; Miyka will abort if the actual file type on the host does not match the expected type.

;; Clone and deploy a git repository. Uncomment and customize the URL to use.
;; (git \"git://vau.place/dotfiles\")

(move-home)             ;; Set the $HOME environment variable to the location of the workspace.


;; Execute shell commands asynchronously such that they are disowned.
;; This means that these commands will not be waited for by Miyka, and
;; their parent process will become PID 1 (init process) instead of Miyka.
;; (detach)

;; Run the init.sh script via /bin/sh.
(shell \".config/miyka/init.sh\")

")
