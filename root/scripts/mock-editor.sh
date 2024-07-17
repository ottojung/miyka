#! /bin/sh

set -e

FILEPATH="$1"
shift

if ! test -z "$CONTENTS"
then
    printf '%s' "$CONTENTS" > "$FILEPATH"
    exit 0
fi

if ! test -z "$SED_EXPRESSION"
then
    TMPFILE="$(mktemp)"
    cat -- "$FILEPATH" | sed "$SED_EXPRESSION" > "$TMPFILE"
    mv -T -- "$TMPFILE" "$FILEPATH"
    exit 0
fi
