;;;; Copyright (C) 2024  Otto Jung
;;;; This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.

(define relative-path-script:template "

function alen(a, i, k) {
    k = 0
    for(i in a) k++
    return k
}

function mylen(a) {
    return alen(a, _mylen_i, _mylen_k)
}

function stack_push(stack, element) {
    stack[mylen(stack) + 1] = element
}

function stack_pop(stack, ret) {
    ret = stack[mylen(stack)]
    delete stack[mylen(stack)]
    return ret
}

function stack_peek(stack) {
    return stack[mylen(stack)]
}

function stack_initialize(stack) {
    delete stack[0]
    delete stack
}

function stack_is_empty(stack) {
    if (mylen(stack) == 0) {
        return 1
    } else {
        return 0
    }
}

function path_pop(parts) {
    is_root_here = parts[1] == \"\"

    if (stack_is_empty(parts)) {
        stack_push(parts, \"..\")
    } else if (stack_peek(parts) == \"..\") {
        stack_push(parts, \"..\")
    } else if (is_root_here && mylen(parts) == 1) {
        return
    } else {
        stack_pop(parts, whatever)
    }
}

function path_push(parts, element) {
    stack_push(parts, element)
}

function parts_to_string(parts) {
    ret = \"\"
    for (i = 1; i <= mylen(parts); i++) {
        if (i > 1) {
            ret = ret \"/\"
        }
        ret = ret parts[i]
    }
    return ret
}

function parse_path(path, parts) {
    stack_initialize(parts)
    split(path, parts, \"/\")
}

function path_simplify(path, simplified_path) {
    parse_path(path, parts)
    stack_initialize(simplified)
    is_root = parts[1] == \"\"

    l = mylen(parts)
    for (i = 1; i <= l; i++) {
        part = parts[i]
        if (part == \".\" || part == \"\") {
            continue
        } else if (part == \"..\") {
            path_pop(simplified)
        } else {
            path_push(simplified, part)
        }
    }

    simplified_path = parts_to_string(simplified)
    if (simplified_path == \"\") {
        if (is_root) {
            simplified_path = \"/\"
        } else {
            simplified_path = \".\"
        }
    }

    return simplified_path
}

function relative_append(path1, path2) {
    parse_path(path1, parts1)
    parse_path(path2, parts2)

    i = 0
    while (1) {
        if (i + 1 > mylen(parts1) || i + 1 > mylen(parts2)) {
            k = i + 1
            w = i + 1
            break
        }

        i = i + 1
        if (parts1[i] != parts2[i]) {
            k = i
            w = i
            break
        }
    }

    stack_initialize(relative_append_ret)

    l = mylen(parts1)
    while (k <= l) {
        stack_push(relative_append_ret, \"..\")
        k = k + 1
    }

    l = mylen(parts2)
    while (w <= l) {
        stack_push(relative_append_ret, parts2[w])
        w = w + 1
    }

    s = parts_to_string(relative_append_ret)
    return s
}

BEGIN {
    simple_first = path_simplify(first_path)
    simple_second = path_simplify(second_path)
    print(relative_append(simple_first, simple_second))
}

")

