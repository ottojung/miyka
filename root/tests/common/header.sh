#! /bin/sh

set -xe

GUILE="guile --r7rs -L src/ -L tests/ -s"
MIYKA=dist/miyka

t_miyka() {
    $MIYKA "$@"
}
