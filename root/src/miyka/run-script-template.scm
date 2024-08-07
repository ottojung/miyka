;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define run-script:template
  "#! /bin/sh

get_guix() {
    if test -z \"$1\"
    then
        if test -z \"$MIYKA_GUIX_EXECUTABLE\"
        then command -v guix
        else printf '%s' \"$MIYKA_GUIX_EXECUTABLE\"
        fi
    else
        printf '%s' \"$1\"
    fi
}

get_miyka_root() {
    if test -z \"$MIYKA_ROOT\"
    then
        if test -z \"$XDG_DATA_HOME\"
        then printf '%s' \"$HOME/.local/share/miyka/root\"
        else printf '%s' \"$XDG_DATA_HOME/miyka/root\"
        fi
    else
        printf '%s' \"$MIYKA_ROOT\"
    fi
}

get_fetcher() {
    if test -z \"$1\"
    then
        if test -z \"$MIYKA_FETCHER\"
        then true
        else
            case \"$MIYKA_FETCHER\" in
                /*)
                    printf '%s' \"$MIYKA_FETCHER\"
                    ;;
                *)
                    command -v \"$MIYKA_FETCHER\"
                    ;;
            esac
        fi
    else
        case \"$1\" in
            /*)
                printf '%s' \"$1\"
                ;;
            *)
                command -v \"$1\"
                ;;
        esac
    fi
}

exec /bin/sh -- \"${0%/*}\"/run-sync.sh \"${0%/*}\" \"$(get_guix \"$1\")\" \"$(get_miyka_root)\" \"$HOME\" \"$(get_fetcher \"$2\")\"

")
