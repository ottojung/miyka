#! /bin/sh

. tests/common/header.sh

t_miyka create "test-project"

RESULT=$(echo | t_miyka run "test-project")
case "$RESULT" in
    shell*)
        echo "Unexpected shell" 1>&2
        exit 1
        ;;
    *)
        ;;
esac

RESULT=$(echo | t_miyka run "test-project")
case "$RESULT" in
    shell*)
        echo "Unexpected shell" 1>&2
        exit 1
        ;;
    *)
        ;;
esac

RESULT=$(echo | t_miyka --guix-executable "$PWD/scripts/guix-echo-mock.sh" run "test-project")
case "$RESULT" in
    shell*) ;;
    *)
        echo "Expected shell" 1>&2
        exit 1
        ;;
esac

export MIYKA_GUIX_EXECUTABLE="$PWD/scripts/guix-echo-mock.sh"
RESULT=$(echo | t_miyka run "test-project")
case "$RESULT" in
    shell*) ;;
    *)
        echo "Expected shell" 1>&2
        exit 1
        ;;
esac
