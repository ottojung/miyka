;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define start-script:template
  "#! /bin/sh

#################################
# Get current script directory. #
#################################

SCRIPT_PATH=\"$0\"
case \"$SCRIPT_PATH\" in
    /*) ;; # Absolute path.
    *) SCRIPT_PATH=\"$PWD/$SCRIPT_PATH\" ;; # Convert relative to absolute.
esac

# Extract directory.
DIR_PATH=\"${SCRIPT_PATH%/*}\"
test \"$DIR_PATH\" = \"$SCRIPT_PATH\" && DIR_PATH='.'

###################################
# Initialize MIYKA env variables. #
###################################

export MIYKA_REPO_HOME=\"$DIR_PATH/../..\"
export MIYKA_REPO_PATH=\"$MIYKA_REPO_HOME/../..\"
export MIYKA_ORIG_HOME=\"$HOME\"

#################################

export SHELL=sh
~a
export PATH=\"$MIYKA_REPO_HOME/.local/bin:$PATH:$MIYKA_REPO_PATH/wd/bin\"
cd -- \"$MIYKA_REPO_HOME\"
test -f \"$HOME/.profile\" && . \"$HOME/.profile\"
~a
")
