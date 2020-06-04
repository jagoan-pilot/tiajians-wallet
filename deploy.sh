language: android
jdk: oraclejdk8

env:
  global:
    - ANDROID_NDK_VERSION=r15c
    - ANDROID_NDK_HOME=/opt/android-ndk
    - ADB_INSTALL_TIMEOUT=20 # minutes (2 minutes by default)
    - CMAKE_VERSION=cmake-3.6.3
    - ANDROID_BUILD_TOOLS_VERSION=28.0.2

before_install:
  # Install SDK license so Android Gradle plugin can install deps.
  - mkdir "$ANDROID_HOME/licenses" || true
  - echo "d56f5187479451eabf01fb78af6dfcb131a6481e" > "$ANDROID_HOME/licenses/android-sdk-license"
  - echo "24333f8a63b6825ea9c5514f83c2829b004d1fee" > "$ANDROID_HOME/licenses/android-sdk-license"
  # Install the rest of tools (e.g., avdmanager).
  - sdkmanager tools
  # Install the system image.
  - sdkmanager "system-images;android-21;default;armeabi-v7a"
  # Create and start emulator for the script. Meant to race the install task.
  # - echo no | avdmanager create avd --force -n test -k "system-images;android-21;default;armeabi-v7a"
  # - $ANDROID_HOME/emulator/emulator -avd test -no-audio -no-window &
  - rm -rf "$ANDROID_NDK_HOME"
  - mkdir /opt/android-ndk-tmp
  - cd /opt/android-ndk-tmp
  - wget -q https://dl.google.com/android/repository/android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip | cat
  - unzip -q android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip | cat
  - mv ./android-ndk-${ANDROID_NDK_VERSION} ${ANDROID_NDK_HOME}
  - cd ${ANDROID_NDK_HOME}
  - rm -rf /opt/android-ndk-tmp
  - cd ${TRAVIS_BUILD_DIR}

install:
  - echo y | sdkmanager 'cmake;3.6.4111459' | grep -v "=$"
  - echo y | sdkmanager 'lldb;3.0' | grep -v "=$"

before_script:
  - export ANDROID_NDK_HOME=$ANDROID_NDK_HOME
#  - android-wait-for-emulator
#  - adb shell settings put global window_animation_scale 0 &
#  - adb shell settings put global transition_animation_scale 0 &
#  - adb shell settings put global animator_duration_scale 0 &
#  - adb shell input keyevent 82 &

android:
  components:
    # Uncomment the lines below if you want to
    # use the latest revision of Android SDK Tools
    - tools
    - platform-tools
    - tools
    - build-tools-$ANDROID_BUILD_TOOLS_VERSION
    - android-15
    - android-25
    - android-21
    - android-28
    # Support library
    - extra-android-support
    # Latest artifacts in local repository
    - extra-google-m2repository
    - extra-android-m2repository
    # Specify at least one system image
    # - sys-img-armeabi-v7a-android-$ANDROID_API_LEVEL

    #allow licenses
  licenses:
    - 'android-sdk-preview-license-+'
    - 'android-sdk-license-.+'
    - 'google-gdk-license-.+'

#Notifications
notifications:
  email: false

script:
#- ./gradlew test
- ./gradlew assemble_testNet3Debug
#- rm -rf .gradle/4.4
#- ./gradlew assembleProdDebug
#- ./gradlew assembleProdRelease

after_success:
  - ls -l wallet/build/outputs/apk/_testNet3/debug/
  - mkdir tmp
  - cd tmp
  - git config --local user.name "tomasz-ludek"
  - git config --local user.email "tomasz@dash.org"
  - git clone https://github.com/tomasz-ludek/travis-staging.git
  - mkdir deploy
  - cp
#  - sh set_tags.sh
before_deploy:
#  - ls -l wallet/build/outputs/apk/_testNet3/debug/
#  - export TRAVIS_TAG="1.$TRAVIS_BUILD_NUMBER"
#  - echo "$TRAVIS_TAG" "$TRAVIS_COMMIT"
#  - git config --local user.name "tomasz-ludek"
#  - git config --local user.email "tomasz@dash.org"
#  - export TRAVIS_TAG=${TRAVIS_TAG:-$(date +'%Y%m%d%H%M%S')-$(git log --format=%h -1)}
#  - git tag $TRAVIS_TAG
deploy:
  provider: script
  script: bash deploy.sh