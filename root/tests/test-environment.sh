#! /bin/sh

. tests/common/header.sh

t_miyka create "test-project"

HOME_PATH=$(t_miyka get home of "test-project")
CONFIG_PATH=$(t_miyka get config-path of "test-project")

TMP="$MIYKA_ROOT/temp1.lisp"
cat -- "$CONFIG_PATH" > "$TMP"
cat "$TMP" | sed 's/(environment /(environment "X1" /' > "$CONFIG_PATH"
rm -f "$TMP"

echo "echo X1 is "'$X1' \
     > "$HOME_PATH/.config/miyka/init.sh"

export X1=42
RESULT=$(t_miyka run "test-project")

test "$RESULT" = "X1 is 42"

export X1=777
RESULT=$(t_miyka run "test-project")
