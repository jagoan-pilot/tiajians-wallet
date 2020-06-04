#!/bin/bash

if [ "${TRAVIS_TAG:0:4}" = "NMA-" ] || [ "${TRAVIS_TAG:0:4}" = "dpl-" ]; then

  cd "$TRAVIS_BUILD_DIR" || exit

  eval "$(ssh-agent -s)" # Start ssh-agent cache
  chmod 600 .deploy/id_rsa # Allow read access to the private key
  ssh-add .deploy/id_rsa # Add the private key to SSH

  echo -e "Let's deploy it!"
  echo "TRAVIS_TAG: $TRAVIS_TAG"
#  ls -l wallet/build/outputs/apk/_testNet3/debug/
  git clone git@github.com:dash-mobile-team/dash-wallet-staging.git
  mkdir -p dash-wallet-staging/"$TRAVIS_TAG"
  cp wallet/build/outputs/apk/_testNet3/debug/dash-wallet-_testNet3-debug.apk dash-wallet-staging/"$TRAVIS_TAG"/dash-wallet-_testNet3-debug.apk
  cp wallet/build/outputs/apk/prod/debug/dash-wallet-prod-debug.apk dash-wallet-staging/"$TRAVIS_TAG"/dash-wallet-prod-debug.apk
#  cp wallet/build/outputs/apk/_testNet3/debug/dash-wallet-_testNet3-debug.apk dash-wallet-staging/"$TRAVIS_TAG"/dash-wallet-_testNet3-debug.apk
  cd dash-wallet-staging || exit
  if [ "${TRAVIS_TAG:0:4}" = "NMA-" ]; then
    printf 'https://dashpay.atlassian.net/browse/%s\n\n' "$TRAVIS_TAG" > README.md
  fi
  git show "$TRAVIS_TAG" >> README.md
  git add .
  git commit -m "travis deploy for $TRAVIS_TAG"
  git push origin master

  # clean up the mess
  cd "$TRAVIS_BUILD_DIR" || exit
  rm -rf dash-wallet-staging
  rm -rf "$TRAVIS_BUILD_DIR"/app/build/outputs
  echo "deleting tag $TRAVIS_TAG"
#  git tag -d "$TRAVIS_TAG"
  git push -q https://"$PERSONAL_ACCESS_TOKEN"@github.com/dashevo/dash-wallet --delete "refs/tags/$TRAVIS_TAG"
else
  echo "Only tags "
fi
echo "Deploy done"