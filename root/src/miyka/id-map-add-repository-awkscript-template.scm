;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define id-map-add-repository-awkscript:template "

function print_new() {
    print(\"\")
    print(\"[[repositories]]\")
    print(\"id = \" new_id)
    print(\"name = \" new_name)
}

BEGIN {
    FS=\"\\n\";
    RS=\"\";
    search_found = 0;
}
{
    match($0, /\\[\\[repositories\\]\\]/);
    block = $0

    if (RSTART != 0 && index(block, \"id = \\\"\" new_id \"\\\"\") != 0) {
        print_new()
        search_found = 1;
    } else {
        print(\"\")
        print($0)
    }
}

END {
    if (search_found == 0) {
        print_new()
    }
}

")
