;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define make-helper-env-script:template
  "#! /bin/sh

export MIYKA_STAT_PATH=\"$1\"
shift
export MIYKA_GUIX_EXECUTABLE=\"$1\"
shift
export MIYKA_ROOT=\"$1\"
shift
export MIYKA_ORIG_HOME=\"$1\"
shift

export MIYKA_REPO_HOME=\"$MIYKA_STAT_PATH/../home\"
export MIYKA_WORK_PATH=\"$MIYKA_STAT_PATH/..\"
export MIYKA_REPO_PATH=\"$MIYKA_WORK_PATH/..\"

export SHELL=/bin/sh

exec \"$@\"

")
