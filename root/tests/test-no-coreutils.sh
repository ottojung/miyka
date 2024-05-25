#! /bin/sh

. tests/common/header.sh

t_miyka create test-project

echo '(install "bc") (shell ".config/miyka/init.sh") (move-home)' \
     > "$MIYKA_ROOT/repositories/test-project/wd/home/.config/miyka/configuration.lisp"

echo 'echo 2 + 3 | bc' \
     > "$MIYKA_ROOT/repositories/test-project/wd/home/.config/miyka/init.sh"

RESULT=$(t_miyka run test-project)

test "$RESULT" = "5"
