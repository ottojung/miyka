#! /bin/sh

. tests/common/header.sh

t_miyka create test-project

echo 'echo hello ; exit 42' \
     > "$MIYKA_ROOT/repositories/test-project/wd/home/.config/miyka/init.sh"

if t_miyka run test-project
then
    exit 1
else
    test "$?" = "42"
fi
