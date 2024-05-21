;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define start-script:template
  "#! /bin/sh
set -e
export MIYKA_REPO_NAME=\"$1\"
export MIYKA_REPO_PATH=\"$2\"
export MIYKA_ORIG_HOME=\"$HOME\"
export SHELL=dash
~a
export PATH=\"$MIYKA_REPO_PATH/wd/home/.local/bin:$PATH\"
mkdir -p \"$MIYKA_REPO_PATH/wd/home/.local/bin\"
ln -sf /bin/sh \"$MIYKA_REPO_PATH/wd/home/.local/bin/sh\"
cd -- \"$MIYKA_REPO_PATH/wd/home\"
set +e
test -f \"$HOME/.profile\" && . \"$HOME/.profile\"
~a
")
