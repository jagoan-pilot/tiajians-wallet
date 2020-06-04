#!/bin/bash

TAG_NAME=$1
DESCRIPTION=$2

echo
echo "Preparing deploy"
echo

if [ "${TAG_NAME:0:4}" = "nma-" ]; then
  TAG_NAME=${TAG_NAME^^} # convert nma- to NMA-
fi

if [ "${TAG_NAME:0:4}" = "NMA-" ] || [ "${TAG_NAME:0:4}" = "dpl-" ]; then
  # sync tags with remote
  git tag -l | xargs git tag -d > /dev/null 2>&1
  git fetch --tags > /dev/null 2>&1

  if [ "${TAG_NAME:0:4}" = "NMA-" ]; then
    TAG_MESSAGE="JIRA ticket: https://dashpay.atlassian.net/browse/$TAG_NAME"
  else
    TAG_MESSAGE="$TAG_NAME"
  fi
  echo "Creating tag for $TAG_MESSAGE"
  if [ -z "$DESCRIPTION" ]; then
    echo "Description: $DESCRIPTION"
  fi
  # create annotated tag
  git tag -a "$TAG_NAME" -m "$TAG_MESSAGE"

  git push origin "$TAG_NAME"

else
  echo "Specify JIRA ticket \"NMA-XXX\" or deploy name prefixed with \"dpl-\""
  echo "You can also add a description as a second parameter"
  echo "eg. deploy.sh dpl-RCv8.0.1 \"Minor bug fixes\""
fi
echo
read -n 1 -r -s -p "Press any key to continue..."