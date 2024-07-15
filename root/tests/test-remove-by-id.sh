#! /bin/sh

. tests/common/header.sh

t_miyka create "test-project1"
t_miyka create "test-project2"

PROJECTS="$(t_miyka list)"

test "$PROJECTS" = \
     "test-project1
test-project2"

REPO_ID=$(t_miyka get id of "test-project1")
t_miyka remove id "$REPO_ID"

PROJECTS="$(t_miyka list)"

test "$PROJECTS" = "test-project2"
