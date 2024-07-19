#! /bin/sh

. tests/common/header.sh

t_miyka create "test-project"

HOME_PATH=$(t_miyka get home of "test-project")

echo "echo hello from miyka project" \
     > "$HOME_PATH/.profile"

RESULT=$(echo | t_miyka run "test-project" | grep -e '^hello' || true)

test "$RESULT" = ""
