#! /bin/sh

. tests/common/header.sh

t_miyka create "test-project"

HOME_PATH=$(t_miyka get home of "test-project")

echo "echo hello from miyka project" \
     > "$HOME_PATH/.config/miyka/cleanup.sh"

RESULT=$(echo | t_miyka run "test-project" | grep '^hello')

test "$RESULT" = "hello from miyka project
hello from miyka project"
