#! /bin/sh

. tests/common/header.sh

if t_miyka import id 'some-fake-id-here' as 'some-name'
then
    echo "Did not expect import to succeed without a fetcher." 1>&2
    exit 1
fi
