#!/bin/sh
set -eo pipefail

# Create a custom keychain
security create-keychain -p travis ios-build.keychain

# Make the custom keychain default, so xcodebuild will use it for signing
security default-keychain -s ios-build.keychain

# Unlock the keychain
security unlock-keychain -p travis ios-build.keychain

# Set keychain timeout to 1 hour for long builds
# see http://www.egeek.me/2013/02/23/jenkins-and-xcode-user-interaction-is-not-allowed/
security set-keychain-settings -t 3600 -l ~/Library/Keychains/ios-build.keychain

sftp builderfiles@packages.breez.technology:config/conf/cert_github.p12 ~/ios_distribution.p12
sftp builderfiles@packages.breez.technology:config/conf/ios_distribution_github.cer ~/ios_distribution.cer
sftp builderfiles@packages.breez.technology:config/conf/apple.cer ~/apple.cer
sftp builderfiles@packages.breez.technology:config/conf/brez_dist_github.mobileprovision ~/brez_dist_github.mobileprovision
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles/

# Add certificates to keychain and allow codesign to access them
security import ~/apple.cer -k ~/Library/Keychains/ios-build.keychain -A
security import ~/ios_distribution.cer -k ~/Library/Keychains/ios-build.keychain -A
security import ~/ios_distribution.p12 -k ~/Library/Keychains/ios-build.keychain -P "$CER_KEY_PASS" -A
security set-key-partition-list -S apple-tool:,apple: -s -k travis ios-build.keychain > /dev/null

# Put the provisioning profile in place
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
cp ~/brez_dist_github.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/