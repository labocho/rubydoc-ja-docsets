#!/usr/bin/env bash
REVISION=$(git log --format=%H -1)
curl --user ${CIRCLE_TOKEN}: \
    --request POST \
    --form revision=${REVISION}\
    --form config=@config.yml \
    --form notify=false \
        https://circleci.com/api/v1.1/project/github/labocho/rubydoc-ja-docsets/tree/master
