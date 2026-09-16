#!/bin/bash
# Build, sign, and notarize Sharktopoda.app for Developer ID distribution.
#
# One-time setup (run once, interactively, before the first release):
#   xcrun notarytool store-credentials "mbari-notary" \
#     --apple-id "<your-apple-id-email>" \
#     --team-id 9TN7A342V4 \
#     --password "<app-specific-password>"
#
# (Generate the app-specific password at https://appleid.apple.com under
# Sign-In and Security > App-Specific Passwords. An App Store Connect API
# key works too — see `xcrun notarytool store-credentials --help`.)
#
# Usage: Scripts/release.sh

set -euo pipefail

PROJECT_NAME="Sharktopoda.xcodeproj"
SCHEME="Sharktopoda"
TEAM_ID="9TN7A342V4"
SIGN_IDENTITY="Developer ID Application"
NOTARY_PROFILE="mbari-notary"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="$ROOT_DIR/build"
ARCHIVE_PATH="$BUILD_DIR/Sharktopoda.xcarchive"
EXPORT_PATH="$BUILD_DIR/export"
EXPORT_OPTIONS="$ROOT_DIR/Scripts/ExportOptions.plist"
APP_PATH="$EXPORT_PATH/$SCHEME.app"
NOTARIZE_ZIP="$BUILD_DIR/$SCHEME-for-notarization.zip"

rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

echo "==> Archiving (Release configuration)"
xcodebuild clean archive \
	-project "$ROOT_DIR/$PROJECT_NAME" \
	-scheme "$SCHEME" \
	-configuration Release \
	-archivePath "$ARCHIVE_PATH" \
	CODE_SIGN_STYLE=Manual \
	CODE_SIGN_IDENTITY="$SIGN_IDENTITY" \
	DEVELOPMENT_TEAM="$TEAM_ID"

echo "==> Exporting signed .app"
xcodebuild -exportArchive \
	-archivePath "$ARCHIVE_PATH" \
	-exportPath "$EXPORT_PATH" \
	-exportOptionsPlist "$EXPORT_OPTIONS"

echo "==> Zipping for notarization submission"
ditto -c -k --keepParent "$APP_PATH" "$NOTARIZE_ZIP"

echo "==> Submitting to Apple's notary service (can take a few minutes)"
xcrun notarytool submit "$NOTARIZE_ZIP" --keychain-profile "$NOTARY_PROFILE" --wait

echo "==> Stapling notarization ticket to the app"
xcrun stapler staple "$APP_PATH"

echo "==> Verifying Gatekeeper acceptance"
spctl -a -vv "$APP_PATH"

echo
echo "Done. Signed & notarized app: $APP_PATH"
echo "Zip it (ditto -c -k --keepParent) or wrap it in a DMG for distribution."
