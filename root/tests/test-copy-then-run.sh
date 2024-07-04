#! /bin/sh

. tests/common/header.sh

t_miyka create "test-project"

HOME_PATH=$(t_miyka get home of "test-project")

echo "echo hello from miyka project" \
     > "$HOME_PATH/.config/miyka/init.sh"

RESULT=$(t_miyka copy "test-project" as "copy-project")

OTHER_HOME_PATH=$(t_miyka get home of "copy-project")

! test "$HOME_PATH" = "$OTHER_HOME_PATH"
! test -e "$OTHER_HOME_PATH/.config/miyka/init.sh"

mkdir -p "$OTHER_HOME_PATH/.config/miyka"
echo "echo hello from copy project" \
     > "$OTHER_HOME_PATH/.config/miyka/init.sh"

RESULT=$(t_miyka run "test-project")
OTHER_RESULT=$(t_miyka run "copy-project")

test "$RESULT" = "hello from miyka project"
test "$OTHER_RESULT" = "hello from copy project"
