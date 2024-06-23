#! /bin/sh

. tests/common/header.sh

t_miyka create "test-project"

HOME_PATH=$(t_miyka get home of "test-project")
CONFIG_PATH=$(t_miyka get config path of "test-project")

echo '(shell ".config/miyka/init.sh") (move-home)' \
     > "$CONFIG_PATH"

echo 'echo 2 + 3' \
     > "$HOME_PATH/.config/miyka/init.sh"

RESULT=$(t_miyka run "test-project")

test "$RESULT" = "2 + 3"
