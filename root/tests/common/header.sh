#! /bin/sh

set -e
set -x

GUILE="guile --r7rs -L src/ -L tests/ -s"
MIYKA=dist/miyka

t_miyka() {
    $MIYKA "$@"
}

TESTNAME="$(basename "$0")"
export MIYKA_ROOT=dist/testroot/"$TESTNAME"
rm -rf "$MIYKA_ROOT" 1>&2
