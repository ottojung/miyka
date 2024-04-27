#! /bin/sh

set -e

GUILE="guile --r7rs -L src/ -L tests/ -s"
MIYKA=dist/miyka

TESTNAME="$(basename "$0")"
export MIYKA_ROOT=dist/testroot/"$TESTNAME"

t_miyka() {
    $MIYKA "$@"
}

set -x
