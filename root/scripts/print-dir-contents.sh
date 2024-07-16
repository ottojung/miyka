#! /bin/sh

set -e

DIR="$1"
shift

CAT="$(command -v cat)"
SHA="$(command -v sha256sum)"

find -- "$DIR" | sort | while IFS= read PATH
do
    if test -f "$PATH"
    then
        printf '> '
        "$SHA" -- "$PATH"
        "$CAT" -- "$PATH"
        printf '> '
        "$SHA" -- "$PATH"
    else
        echo "> - $PATH"
    fi
done
