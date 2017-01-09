#!/bin/bash
trigger_build_url=https://circleci.com/api/v1/project/labocho/rubydoc-ja-docsets/tree/master?circle-token=${CIRCLE_TOKEN}

post_data=$(cat <<EOF
{
  "build_parameters": {
    "BUILD_DOCSETS": "true"
  }
}
EOF)

curl \
--header "Accept: application/json" \
--header "Content-Type: application/json" \
--data "${post_data}" \
--request POST ${trigger_build_url}
