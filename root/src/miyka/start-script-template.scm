;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define start-script:template
  "#! /bin/sh
set -e
export PATH=\"/bin:$PATH\"
export MIYKA_REPO_NAME=\"$1\"
export MIYKA_REPO_PATH=\"$2\"
export HOME=\"$MIYKA_REPO_PATH/home\"
mkdir -p -- \"$HOME\"
cd -- \"$HOME\"
test -f .config/miyka/init.sh && sh .config/miyka/init.sh
")
