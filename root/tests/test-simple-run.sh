#! /bin/sh

. tests/common/header.sh

t_miyka create "test-project"

HOME_PATH=$(t_miyka get home of "test-project")

echo "echo hello from miyka project" \
     > "$HOME_PATH/.config/miyka/run.sh"

RESULT=$(t_miyka run "test-project")

test "$RESULT" = "hello from miyka project"
