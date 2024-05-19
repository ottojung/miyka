#! /bin/sh

. tests/common/header.sh

t_miyka create test-project1
t_miyka create test-project2

PROJECTS="$(t_miyka list)"

test "$PROJECTS" = \
     "test-project1
test-project2"
