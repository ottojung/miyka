#! /bin/sh

. tests/common/header.sh

t_miyka create "test-project1"

HOME_PATH=$(t_miyka get home of "test-project1")
ROOT_PATH=$(t_miyka get root-path of "test-project1")

if ! test -d "$HOME_PATH"
then
    echo "Home does not exist." 1>&2
    exit 1
fi

TMP="$MIYKA_ROOT/testdir"
mkdir -p -- "$TMP"
rmdir "$TMP"

mv -T -- $(readlink -f "$ROOT_PATH") "$TMP"

if test -d "$HOME_PATH"
then
    echo "Home exist." 1>&2
    exit 1
fi

RESULT=$(t_miyka import directory "$TMP" as "test-project2")

if ! test -d "$HOME_PATH"
then
    echo "Home does not exist." 1>&2
    exit 1
fi
