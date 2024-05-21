#! /bin/sh

. tests/common/header.sh

t_miyka create test-project

echo "echo hello from miyka project" \
     > "$MIYKA_ROOT/repositories/test-project/wd/home/.config/miyka/cleanup.sh"

RESULT=$(echo | t_miyka run test-project)

test "$RESULT" = "hello from miyka project
hello from miyka project"
