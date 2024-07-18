#! /bin/sh

DEST="$MIYKA_FETCHER_ARG_DESTINATION"

mkdir -p -- "$DEST"
mkdir -p -- "$DEST"/"wd/state"
mkdir -p -- "$DEST"/"wd/home/.config/miyka"

echo "testid" > "$DEST"/"wd/id.txt"

echo "echo hello from fetched repository" > "$DEST"/"wd/home/.config/miyka/run.sh"
echo '(shell ".config/miyka/run.sh")' > "$DEST"/"wd/configuration.lisp"
