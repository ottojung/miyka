#! /bin/sh

. tests/common/header.sh

t_miyka create "test-project"

HOME_PATH=$(t_miyka get home of "test-project")

echo 'echo hello ; exit 42' \
     > "$HOME_PATH/.config/miyka/run.sh"

if t_miyka run "test-project"
then
    exit 1
else
    test "$?" = "42"
fi
