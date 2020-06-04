#!/bin/bash

echo -e "Let\'s rock!"
DEPLOY_DATE=$(date +%Y%m%dT%H%M%S)
export DEPLOY_DATE
echo "Deploy date $DEPLOY_DATE"
export DEPLOY_FILE_NAME=dash-wallet-_testNet3-debug-$DEPLOY_DATE.apk
ls -l wallet/build/outputs/apk/_testNet3/debug/
#git config --local user.name "tomasz-ludek"
#git config --local user.email "tomasz@dash.org"
git clone https://github.com/tomasz-ludek/travis-staging.git
cp wallet/build/outputs/apk/_testNet3/debug/dash-wallet-_testNet3-debug.apk travis-staging/$DEPLOY_FILE_NAME
cd travis-staging || exit
git add .
git commit -m "travis deploy $DEPLOY_DATE"
git push origin master
cd ..
rm -rf travis-staging
echo "Deploy done"