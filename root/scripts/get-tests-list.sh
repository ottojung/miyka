#! /bin/sh

CI_TESTS="
"

for FILE in tests/*
do
	case "$FILE" in
		tests/test-*) ;;
		*) continue ;;
	esac

	if echo "$CI_TESTS" | grep -q -F -e "$FILE"
	then
		if ! test "$CI" = 1
		then
			continue
		fi
	fi

	echo "$FILE"
done
