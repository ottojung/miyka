#! /bin/sh

. tests/common/header.sh

t_miyka create "test-project"
HOME_PATH=$(t_miyka get home of "test-project")

mkdir -p -- "$HOME_PATH"/"my repos"/"some repo directory"
mkdir -p -- "$HOME_PATH"/"my repos"/"some repo directory"/"wd"
mkdir -p -- "$HOME_PATH"/"my repos"/"some repo directory"/"wd"/"state"
echo "someidvalue" > "$HOME_PATH"/"my repos"/"some repo directory"/"wd"/"id.txt"
echo "echo hello from script" > "$HOME_PATH"/"my repos"/"some repo directory"/"wd"/"state"/"run.sh"

export EDITOR=scripts/mock-editor.sh
export SED_EXPRESSION='s#^.*import directory.*$#(import directory "my repos/some repo directory" as "my-exe-name")#'
t_miyka edit "test-project"

echo "my-exe-name ; my-exe-name" > "$HOME_PATH"/".config"/"miyka"/"run.sh"
RESULT=$(echo | t_miyka run "test-project")

test "$RESULT" = "hello from script
hello from script"
