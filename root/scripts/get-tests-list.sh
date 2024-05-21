#! /bin/sh

CI_TESTS="
"

GUIX_TESTS="
tests/test-simple-run.sh
tests/test-run-reads-profile.sh
tests/test-copy-then-run.sh
"

if command -v guix 1>/dev/null 2>/dev/null
then
	HAVE_GUIX=1
fi

for FILE in tests/*
do
	case "$FILE" in
		tests/test-*) ;;
		*) continue ;;
	esac

	if echo "$GUIX_TESTS" | grep -q -F -e "$FILE"
	then
		if ! test "$HAVE_GUIX" = 1
		then
			continue
		fi
	fi

	if echo "$CI_TESTS" | grep -q -F -e "$FILE"
	then
		if ! test "$CI" = 1
		then
			continue
		fi
	fi

	echo "$FILE"
done
