#! /bin/sh

. tests/common/header.sh

export MIYKA_FETCHER=tests/common/fake-fetcher.sh
t_miyka import id 'some-fake-id-here' as 'some-name'

RESULT=$(t_miyka run 'some-name')

test "$RESULT" = "hello from fetched repository"
