#! /bin/sh

set -e

DIR="$1"
shift

ALS="$(command -v ls)"
CAT="$(command -v cat)"
SHA="$(command -v sha256sum)"

find -- "$DIR" | sort | while IFS= read PATH
do
    printf '> %s' "$PATH"
    echo
    "$ALS" -a -- "$PATH" 2>/dev/null || continue
    echo

    if test -L "$PATH"
    then true
    else
        if test -f "$PATH"
        then
            "$SHA" -- "$PATH"
            "$CAT" -- "$PATH"
            "$SHA" -- "$PATH"
        fi
    fi
done
