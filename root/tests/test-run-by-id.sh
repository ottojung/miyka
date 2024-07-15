#! /bin/sh

. tests/common/header.sh

t_miyka create "test-project"

HOME_PATH=$(t_miyka get home of "test-project")

echo "echo hello from miyka project" \
     > "$HOME_PATH/.config/miyka/run.sh"

REPO_ID=$(t_miyka get id of "test-project")

RESULT=$(t_miyka run id "$REPO_ID")

test "$RESULT" = "hello from miyka project"
