#! /bin/sh

. tests/common/header.sh

t_miyka create test-project

mkdir -p "$MIYKA_ROOT/repositories/test-project/home/.config/miyka"

echo "echo hello from miyka project" \
     > "$MIYKA_ROOT/repositories/test-project/home/.config/miyka/init.sh"

RESULT=$(t_miyka run test-project)

test "$RESULT" = "hello from miyka project"