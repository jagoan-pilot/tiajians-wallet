#!/bin/bash

eval "$(ssh-agent -s)" # Start ssh-agent cache
chmod 600 .travis/id_rsa # Allow read access to the private key
ssh-add .travis/id_rsa # Add the private key to SSH

echo -e "Let\'s deploy it!"
DEPLOY_DATE=$(date +%Y%m%dT%H%M%S)
export DEPLOY_DATE
echo "Deploy date $DEPLOY_DATE"
echo "TRAVIS_TAG $TRAVIS_TAG"
echo "TRAVIS_BUILD_NUMBER $TRAVIS_BUILD_NUMBER"
export DEPLOY_FILE_NAME=dash-wallet-_testNet3-debug-$DEPLOY_DATE.apk
ls -l wallet/build/outputs/apk/_testNet3/debug/
git clone git@github.com:dash-mobile-team/dash-wallet-staging.git
cp wallet/build/outputs/apk/_testNet3/debug/dash-wallet-_testNet3-debug.apk dash-wallet-staging/"$DEPLOY_FILE_NAME"
cd dash-wallet-staging || exit
git add .
git commit -m "travis deploy $DEPLOY_DATE"
git push origin master
cd ..
rm -rf dash-wallet-staging
rm -rf "$TRAVIS_BUILD_DIR"/app/build/outputs
if [ "${TRAVIS_TAG:0:3}" = "NMA" ]; then
  echo "deleting tag $TRAVIS_TAG"
  git tag -d $TRAVIS_TAG
fi
echo "Deploy done"