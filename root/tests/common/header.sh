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
rm -rvf "$MIYKA_ROOT" 1>&2
docker image rm miyka/test-project 1>&2 || true
