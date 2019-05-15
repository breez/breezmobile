#!/bin/sh
if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
  echo "This is a pull request. No deployment will be done."
  exit 0
fi
# if [[ "$TRAVIS_BRANCH" != "master" ]]; then
#   echo "Testing on a branch other than master. No deployment will be done."
#   exit 0
# fi

PROVISIONING_PROFILE="$HOME/Library/MobileDevice/Provisioning Profiles/$PROFILE_NAME.mobileprovision"
OUTPUTDIR="$PWD/build/ios/Release-iphoneos"
IDENTITY=$(security find-identity -v -p codesigning | awk '{print $2;}' | head -1)

#codesign --entitlements "ios/Runner/Runner.entitlements" -s $IDENTITY "$OUTPUTDIR/$APP_NAME.app"
pushd ios
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $TRAVIS_JOB_NUMBER" Runner/Info.plist
travis_wait xcodebuild -quiet -workspace Runner.xcworkspace -scheme Runner -sdk iphoneos -configuration Release archive -archivePath $PWD/build/Runner.xcarchive
travis_wait xcodebuild -quiet -exportArchive -archivePath $PWD/build/Runner.xcarchive -exportOptionsPlist ../travis/export-options.plist -exportPath $PWD/build/Runner.ipa

#upload to testflight
altool="$(dirname "$(xcode-select -p)")/Applications/Application Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Support/altool"
ipa="$PWD/build/Runner.ipa"
"$altool" --upload-app --type ios --file "$ipa" --username $APP_USERNAME --password $APP_PASSWORD