#! /bin/sh

. tests/common/header.sh

t_miyka create "test-project"

t_miyka list

REPO_ID=$(t_miyka get id of "test-project")
RESULT=$(t_miyka get name of id "$REPO_ID")

test "$RESULT" = "test-project"
