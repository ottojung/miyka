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
export SED_EXPRESSION='s#^.*import directory.*$#(import id "test17237123id" as "my-exe-name-217371")#'
t_miyka edit "test-project"

export MIYKA_FETCHER="$PWD/tests/common/fake-fetcher.sh"
echo "my-exe-name-217371 ; my-exe-name-217371" > "$HOME_PATH"/".config"/"miyka"/"run.sh"
RESULT=$(echo | t_miyka run "test-project")

test "$RESULT" = "hello from the run script of fetched repository
hello from the run script of fetched repository"
