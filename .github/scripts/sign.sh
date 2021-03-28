#!/bin/sh
set -eo pipefail

pushd ios
buildNumber=$(($GITHUB_RUN_NUMBER + 4000)).1
GOOGLE_SIGN_IN_URL=$(/usr/libexec/PlistBuddy -c "Print :REVERSED_CLIENT_ID" Runner/GoogleService-Info.plist)
/usr/libexec/PlistBuddy -c "Set :CFBundleURLTypes:0:CFBundleURLSchemes:0 $GOOGLE_SIGN_IN_URL" Runner/Info.plist
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" Runner/Info.plist
xcodebuild -quiet -workspace Runner.xcworkspace -scheme Runner -sdk iphoneos -configuration Release archive -archivePath $PWD/build/Runner.xcarchive
echo "after build"
zip -r "symbols_$buildNumber.zip" ./build/Runner.xcarchive/dSYMs/Runner.app.dSYM
export uploadCommand="put symbols_$buildNumber.zip"
sftp builderfiles@packages.breez.technology:config/conf <<< $uploadCommand
xcodebuild -quiet -exportArchive -archivePath $PWD/build/Runner.xcarchive -exportOptionsPlist ../.github/scripts/export-options.plist -exportPath $PWD/build/Runner.app

ls -lrt $PWD/build/Runner.app
echo "after archive"
#upload to testflight
altool="$(dirname "$(xcode-select -p)")/Developer/usr/bin/altool"
ipa="$PWD/build/Runner.app/breez.ipa"
export uploadCommand="put $ipa"
sftp builderfiles@packages.breez.technology:config/conf <<< $uploadCommand
"$altool" --upload-app --type ios --file "$ipa" --username $APP_USERNAME --password $APP_PASSWORD