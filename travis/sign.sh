#!/bin/sh
if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
  echo "This is a pull request. No deployment will be done."
  exit 0
fi
# if [[ "$TRAVIS_BRANCH" != "master" ]]; then
#   echo "Testing on a branch other than master. No deployment will be done."
#   exit 0
# fi


pushd ios
GOOGLE_SIGN_IN_URL=$(/usr/libexec/PlistBuddy -c "Print :REVERSED_CLIENT_ID" Runner/GoogleService-Info.plist)
/usr/libexec/PlistBuddy -c "Set :CFBundleURLTypes:0:CFBundleURLSchemes:0 $GOOGLE_SIGN_IN_URL" Runner/Info.plist
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $TRAVIS_JOB_NUMBER" Runner/Info.plist
xcodebuild -quiet -workspace Runner.xcworkspace -scheme Runner -sdk iphoneos -configuration Release archive -archivePath $PWD/build/Runner.xcarchive

zip -r "symbols_$TRAVIS_JOB_NUMBER.zip" ./build/Runner.xcarchive/dSYMs/Runner.app.dSYM
export uploadCommand="put symbols_$TRAVIS_JOB_NUMBER.zip"
sftp builderfiles@packages.breez.technology:config/conf <<< $uploadCommand
xcodebuild -quiet -exportArchive -archivePath $PWD/build/Runner.xcarchive -exportOptionsPlist ../travis/export-options.plist -exportPath $PWD/build/Runner.ipa

#upload to testflight
altool="$(dirname "$(xcode-select -p)")/Applications/Application Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Support/altool"
ipa="$PWD/build/Runner.ipa/Runner.ipa"
"$altool" --upload-app --type ios --file "$ipa" --username $APP_USERNAME --password $APP_PASSWORD