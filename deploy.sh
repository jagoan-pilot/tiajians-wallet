#!/bin/bash

eval "$(ssh-agent -s)" # Start ssh-agent cache
chmod 600 .travis/id_rsa # Allow read access to the private key
ssh-add .travis/id_rsa # Add the private key to SSH

echo -e "Let\'s rock!"
DEPLOY_DATE=$(date +%Y%m%dT%H%M%S)
export DEPLOY_DATE
echo "Deploy date $DEPLOY_DATE"
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
echo "Deploy done"