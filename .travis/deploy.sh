#!/bin/bash

if [ "${TRAVIS_TAG:0:3}" = "NMA" ]; then

  cd "$TRAVIS_BUILD_DIR" || exit

  eval "$(ssh-agent -s)" # Start ssh-agent cache
  chmod 600 .travis/id_rsa # Allow read access to the private key
  ssh-add .travis/id_rsa # Add the private key to SSH

  echo -e "Let\'s deploy it!"
#  DEPLOY_DATE=$(date +%Y%m%dT%H%M%S)
#  export DEPLOY_DATE
  echo "TRAVIS_TAG: $TRAVIS_TAG"
  echo "TRAVIS_BUILD_NUMBER: $TRAVIS_BUILD_NUMBER"
#  export DEPLOY_FILE_NAME=dash-wallet-_testNet3-debug-$DEPLOY_DATE.apk
#  ls -l wallet/build/outputs/apk/_testNet3/debug/
  git clone git@github.com:dash-mobile-team/dash-wallet-staging.git
  mkdir -p dash-wallet-staging/"$TRAVIS_TAG"
  cp wallet/build/outputs/apk/_testNet3/debug/dash-wallet-_testNet3-debug.apk dash-wallet-staging/"$TRAVIS_TAG"/dash-wallet-_testNet3-debug.apk
#  cp wallet/build/outputs/apk/prod/debug/dash-wallet-prod-debug.apk dash-wallet-staging/"$TRAVIS_TAG"/dash-wallet-prod-debug.apk
#  cp wallet/build/outputs/apk/_testNet3/debug/dash-wallet-_testNet3-debug.apk dash-wallet-staging/"$TRAVIS_TAG"/dash-wallet-_testNet3-debug.apk
  cd dash-wallet-staging || exit
  date > file.txt
  git add .
  git commit -m "travis deploy for $TRAVIS_TAG"
  git push origin master

  # do some clean-up
  cd "$TRAVIS_BUILD_DIR" || exit
  rm -rf dash-wallet-staging
  rm -rf "$TRAVIS_BUILD_DIR"/app/build/outputs
  echo "deleting tag $TRAVIS_TAG"
#  git tag -d "$TRAVIS_TAG"
  git config --list
  git push --delete origin "$TRAVIS_TAG"

else
  echo "Only tags "
fi
echo "Deploy done"