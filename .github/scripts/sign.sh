#!/bin/sh
set -eo pipefail

pushd ios
GOOGLE_SIGN_IN_URL=$(/usr/libexec/PlistBuddy -c "Print :REVERSED_CLIENT_ID" Runner/GoogleService-Info.plist)
/usr/libexec/PlistBuddy -c "Set :CFBundleURLTypes:0:CFBundleURLSchemes:0 $GOOGLE_SIGN_IN_URL" Runner/Info.plist
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $GITHUB_RUN_NUMBER" Runner/Info.plist
xcodebuild -quiet -workspace Runner.xcworkspace -scheme Runner -sdk iphoneos -configuration Release archive -archivePath $PWD/build/Runner.xcarchive
echo "after build"
zip -r "symbols_$GITHUB_RUN_NUMBER.zip" ./build/Runner.xcarchive/dSYMs/Runner.app.dSYM
export uploadCommand="put symbols_$GITHUB_RUN_NUMBER.zip"
sftp builderfiles@packages.breez.technology:config/conf <<< $uploadCommand
xcodebuild -quiet -exportArchive -archivePath $PWD/build/Runner.xcarchive -exportOptionsPlist ../.github/scripts/export-options.plist -exportPath $PWD/build

ls -lrt $PWD/build/
echo "after archive"
#upload to testflight
altool="$(dirname "$(xcode-select -p)")/Developer/usr/bin/altool"
ipa="$PWD/build/Runner.ipa"
export uploadCommand="put $ipa"
#sftp builderfiles@packages.breez.technology:config/conf <<< $uploadCommand
"$altool" --upload-app --type ios --file "$ipa" --username $APP_USERNAME --password $APP_PASSWORD