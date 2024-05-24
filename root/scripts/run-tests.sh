#! /bin/sh

set -e

FILES=$(sh scripts/get-tests-list.sh)
TESTCOUNT=$(echo "$FILES" | wc -w)
INDEX=0
FAILED=0

if ! command -v guix 1>/dev/null 2>/dev/null
then
	echo "Guix not found, using guix mock for testing." 1>&2
	export MIYKA_GUIX_EXECUTABLE="$PWD/scripts/guix-mock.sh"
fi

for FILE in $FILES
do
	INDEX=$((INDEX + 1))
	SHORT="$(basename "$FILE")"

	printf '(%s/%s)' "$INDEX" "$TESTCOUNT"
	printf ' %s ... ' "$SHORT"

	case "$FILE" in

		*.sh)
			if sh "$FILE" 2>"dist/testlog-$INDEX.txt" 1>"dist/testlog-$INDEX.txt"
			then printf '✓'
			else
				printf 'X\n'
				printf ' ----------------\n'
				cat "dist/testlog-$INDEX.txt"
				printf ' ----------------\n'
				FAILED=1
			fi
			printf '\n'
			;;

		*.sld)
			R=$(if guile --r7rs -L "src" -L "tests" -s "$FILE" 2>&1
			    then printf '✓'
			    else printf 'X'
			    fi)
			printf '%s' "$R" | grep -v -e '^;;; ' || true
			printf '%s' "$R" | grep -q -e '✓' || FAILED=1
			;;

	esac
done

if test "$FAILED" = 1
then exit 1
fi
