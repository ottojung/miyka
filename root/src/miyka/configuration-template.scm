;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define configuration:template
  "
(cleanup \".config/miyka/cleanup.sh\") ;; Execute the cleanup script before and after all shell scripts.

(snapshot)              ;; Save a snapshot of the entire workspace efficiently.

;; Restrict environment to listed variables. Comment out to inherit every environment variable from host. If (move-home) is not used, then $HOME will also be inherited.
(environment \"DISPLAY\" \"XDG_RUNTIME_DIR\")

;; Specify packages to be installed within the workspace environment.
(install \"coreutils\") ;; Install basic POSIX utilities.
(install \"nvi\")       ;; Install the POSIX editor \"vi\".
(install \"findutils\") ;; Install the POSIX \"find\" utility.
(install \"diffutils\") ;; Install the POSIX \"diff\" utility.
(install \"grep\")      ;; Install the POSIX \"grep\" utility.
(install \"sed\")       ;; Install the POSIX \"sed\" stream editor.
(install \"gawk\")      ;; Install the POSIX \"awk\" programming language.
(install \"less\")      ;; Install \"less\", a terminal pager program.
(install \"procps\")    ;; Install \"ps\", \"top\", \"pkill\", \"watch\", and several other common utils.
(install \"nss-certs\") ;; Install HTTPS certificates.
(install \"ncurses\")   ;; Install \"ncurses\" which provides \"clear\" and \"reset\" commands, essential for terminal management.
(install \"man-db\")    ;; Install the \"man\" utility.
(install \"glibc-locales\") ;; Install internalization packages. Mainly for UTF8 support.

;; Import Miyka repositories into the current repository. This will provide executables named by them in the resulting repository. Paths are relative to this repo's home.
;; (import directory \"path/to/repository\" as \"my-executable-name\")

(move-home)             ;; Set the $HOME environment variable to the location of the workspace.

;; Run the run.sh script via /bin/sh.
(shell \".config/miyka/run.sh\")

")
