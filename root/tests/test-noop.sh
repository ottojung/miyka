#! /bin/sh

. tests/common/header.sh

t_miyka create "test-project"

REPO_PATH=$(t_miyka get root-path of "test-project")

export CONTENTS=""
export EDITOR=scripts/mock-editor.sh
t_miyka edit "test-project"

RESULT=$(echo | t_miyka run "test-project")
test "$RESULT" = ""

sh scripts/print-dir-contents.sh "$REPO_PATH" >"$MIYKA_ROOT/initial-contents.bin"

RESULT=$(echo | t_miyka run "test-project")
test "$RESULT" = ""

sh scripts/print-dir-contents.sh "$REPO_PATH" >"$MIYKA_ROOT/final-contents.bin"

diff -q -- "$MIYKA_ROOT/initial-contents.bin" "$MIYKA_ROOT/final-contents.bin"
