#! /bin/sh

. tests/common/header.sh

t_miyka create "test-project1"
t_miyka create "test-project2"
t_miyka create "test-project3"

PROJECTS="$(t_miyka list)"

test "$PROJECTS" = \
     "test-project1
test-project2
test-project3"

for PROJ in $PROJECTS
do
    ID=$(t_miyka get id of "$PROJ")
    NAME=$(t_miyka get name of id "$ID")
    test "$NAME" = "$PROJ"
done
