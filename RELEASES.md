# Automated Releases

This project supports automated releases with Fastlane and GitHub Actions.

Workflows:

- release-android.yaml
- release-ios.yaml
- release-macos.yaml

## Triggering releases

- Push a tag in the form: vX.Y.Z
- Example: v1.2.0
- All release workflows also support manual trigger from GitHub Actions.

## Release lanes

- beta
  - Android: uploads to Play internal track as draft.
  - iOS: uploads to TestFlight.
  - macOS: uploads to TestFlight.
- production
  - Android: uploads to Play production track.
  - iOS: uploads to App Store Connect (not auto-submitted).
  - macOS: uploads a signed .pkg to App Store Connect (not auto-submitted).

## Required GitHub secrets

### Android

- ANDROID_KEYSTORE_BASE64
- ANDROID_KEYSTORE_PASSWORD
- ANDROID_KEY_ALIAS
- ANDROID_KEY_PASSWORD
- PLAY_STORE_SERVICE_ACCOUNT_JSON

### iOS

- APP_STORE_CONNECT_API_KEY_ID
- APP_STORE_CONNECT_ISSUER_ID
- APP_STORE_CONNECT_API_PRIVATE_KEY
- IOS_P12_BASE64
- IOS_P12_PASSWORD
- IOS_PROVISIONING_PROFILE_BASE64

### macOS

- APP_STORE_CONNECT_API_KEY_ID
- APP_STORE_CONNECT_ISSUER_ID
- APP_STORE_CONNECT_API_PRIVATE_KEY
- MACOS_P12_BASE64
- MACOS_P12_PASSWORD
- MACOS_PROVISIONING_PROFILE_BASE64
- MACOS_EXPORT_OPTIONS_PLIST_BASE64

For manual runs, optionally set `environment_name` to use a different GitHub Environment than `release`.

## Local dry run

Install dependencies:

- bundle install
- flutter pub get

Build and upload Android beta:

- flutter build appbundle --release
- cd android
- bundle exec fastlane beta

Build and upload iOS beta:

- flutter build ipa --release
- cd ios
- bundle exec fastlane beta

Build, export, and upload macOS production release:

- flutter build macos --release
- xcodebuild -workspace macos/Runner.xcworkspace -scheme Runner -configuration Release -archivePath build/macos/archive/Runner.xcarchive archive
- xcodebuild -exportArchive -archivePath build/macos/archive/Runner.xcarchive -exportPath build/macos/export -exportOptionsPlist <path-to-export-options-plist>
- cd macos
- bundle exec fastlane production
