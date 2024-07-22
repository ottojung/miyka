#! /bin/sh

. tests/common/header.sh

t_miyka create "test-project"
HOME_PATH=$(t_miyka get home of "test-project")

mkdir -p -- "$HOME_PATH"/"my repos"/"some repo directory"
mkdir -p -- "$HOME_PATH"/"my repos"/"some repo directory"/"wd"
mkdir -p -- "$HOME_PATH"/"my repos"/"some repo directory"/"wd"/"state"
echo "someidvalue-1" > "$HOME_PATH"/"my repos"/"some repo directory"/"wd"/"id.txt"
echo "echo hello from script" > "$HOME_PATH"/"my repos"/"some repo directory"/"wd"/"state"/"run.sh"

mkdir -p -- "$HOME_PATH"/"my repos"/"some repo directory 2"
mkdir -p -- "$HOME_PATH"/"my repos"/"some repo directory 2"/"wd"
mkdir -p -- "$HOME_PATH"/"my repos"/"some repo directory 2"/"wd"/"state"
echo "someidvalue-2" > "$HOME_PATH"/"my repos"/"some repo directory 2"/"wd"/"id.txt"
echo "echo hello from script number 2" > "$HOME_PATH"/"my repos"/"some repo directory 2"/"wd"/"state"/"run.sh"

export EDITOR=scripts/mock-editor.sh
export SED_EXPRESSION='s#^.*import directory.*$#(import directory "my repos/some repo directory" as "my-exe-name") (import directory "my repos/some repo directory 2" as "my-exe-name-number-2")#'

t_miyka edit "test-project"

echo "my-exe-name ; my-exe-name-number-2" > "$HOME_PATH"/".config"/"miyka"/"run.sh"
RESULT=$(echo | t_miyka run "test-project")

test "$RESULT" = "hello from script
hello from script number 2"

ROOT_PATH=$(t_miyka get root-path of "test-project")
export MIYKA_ROOT="$ROOT_PATH/wd/state/imported"
RESULT=$(echo | t_miyka list)
test "$RESULT" = 'my-exe-name
my-exe-name-number-2'

RESULT=$(cat "$MIYKA_ROOT/id-map.csv")
test "$RESULT" = 'id,name
someidvalue-1,my-exe-name
someidvalue-2,my-exe-name-number-2'
