;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define enter-script:template
  "#! /bin/sh

#################################
# Get current script directory. #
#################################

SCRIPT_PATH=\"$0\"
DIR_PATH=\"${SCRIPT_PATH%/*}\"

###################################
# Initialize MIYKA env variables. #
###################################

export MIYKA_REPO_HOME=\"$DIR_PATH/..\"
export MIYKA_WORK_PATH=\"$MIYKA_REPO_HOME/../..\"
export MIYKA_ORIG_HOME=\"$HOME\"
export MIYKA_REPO_PATH=\"$MIYKA_WORK_PATH/..\"
export MIYKA_GUIX_EXECUTABLE=guix

if test -z \"$MIYKA_ROOT\"
then
    if test -z \"$XDG_DATA_HOME\"
    then export MIYKA_ROOT=\"$MIYKA_ORIG_HOME/.local/share/miyka/root\"
    else export MIYKA_ROOT=\"$XDG_DATA_HOME/miyka/root\"
    fi
fi

export PATH=\"$MIYKA_REPO_HOME/.local/bin:$PATH:$MIYKA_REPO_PATH/wd/bin\"
export SHELL=sh

############################
# Parse dynamic arguments. #
############################

while true
do
    if test $# = 0
    then
        echo 'Bad number of arguments.' 1>&2
        exit 1
    fi

    case \"$1\" in
        --move-home)
            export HOME=\"$MIYKA_REPO_HOME\"
            ;;
        --guix-executable)
            shift
            export MIYKA_GUIX_EXECUTABLE=\"$1\"
            ;;
        --help)
            echo \"Usage: enter.sh [--move-home] [--guix-executable <path>] -- ARGS...\" 1>&2
            echo \"Run ARGS in workspaces's environment.\" 1>&2
            exit 0
            ;;
        --)
            shift
            break
            ;;
        *)
            echo \"Unknown argument '$1'.\" 1>&2
            exit 1
            ;;
    esac
    shift
done

##############
# Main body. #
##############

cd -- \"$MIYKA_REPO_HOME\"
test -f \"$HOME/.profile\" && . \"$HOME/.profile\"

exec \"$@\"
")
