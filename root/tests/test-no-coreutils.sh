#! /bin/sh

. tests/common/header.sh

t_miyka create test-project

HOME_PATH=$(t_miyka get home of "test-project")

echo '(install "awk") (shell ".config/miyka/init.sh") (move-home)' \
     > "$HOME_PATH/.config/miyka/configuration.lisp"

echo 'echo | awk "{ print 2 + 3 }"' \
     > "$HOME_PATH/.config/miyka/init.sh"

RESULT=$(t_miyka run "test-project")

test "$RESULT" = "5"
