;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define run-script:template
  "#! /bin/sh

if test -z \"$MIYKA_ROOT\"
then
    if test -z \"$XDG_DATA_HOME\"
    then BASE=\"$HOME/.local/share\"
    else BASE=\"$XDG_DATA_HOME\"
    fi

    export MIYKA_ROOT=\"$BASE/miyka/root\"
fi

case \"$MIYKA_ROOT\" in
    /*) ;;
    *)
        export MIYKA_ROOT=\"$PWD/$MIYKA_ROOT\"
        ;;
esac

cd -- \"${0%/*}\"

if test -z \"$MIYKA_GUIX_EXECUTABLE\"
then
    MIYKA_GUIX_EXECUTABLE=\"$(command -v guix)\"
fi

exec ~a
")
