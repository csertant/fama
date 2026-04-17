<p align="center">
	<img src="assets/images/logo.svg" alt="fáma logo" width="320" />
</p>

fáma is a cross-platform news reader built with Flutter. It helps users discover RSS sources, build a personalized feed, save articles for later, and keep reading across devices and platforms.

![GitHub Release](https://img.shields.io/github/v/release/csertant/fama)
![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/csertant/fama/release-android.yaml?label=release-android)
![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/csertant/fama/release-ios.yaml?label=release-ios)
![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/csertant/fama/release-macos-appstore.yaml?label=release-macos)
![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/csertant/fama/test.yaml?label=test)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

## Project Scope

The project focuses on delivering a clean, reliable, and customizable RSS reading experience:

- Discover and subscribe to news sources
- Aggregate and sync articles into a personal feed
- Save articles for later reading
- Manage multiple reading profiles
- Support modern platforms from a single codebase

## App Features

### Personalized feed

- Fetches and syncs articles from subscribed sources
- Marks articles as read or saved
- Automatically refreshes when connectivity returns

### Source discovery and management

- Explore recommended sources
- Filter source recommendations by language, country, category, and genre
- Add custom sources by URL
- Remove subscribed sources anytime

### Saved reading

- Dedicated saved-articles view
- Quickly unsave or mark saved articles as read

### Powerful filtering

- Filter articles by source and author
- Toggle read/unread visibility
- Filter by recent time windows

### Profiles and preferences

- Multiple profiles in one app
- Switch active profile instantly
- Theme selection (light/dark/system)
- Language selection via localization support

### Cross-platform support

- Android
- iOS
- macOS
- Windows
- Linux

## Getting Started

1. Install Flutter (stable) and verify with `flutter doctor`.
2. Get packages:

```bash
flutter pub get
```

3. Run the app (staging providers):

```bash
flutter run --target lib/main.dart
```

4. Run the development entrypoint (development providers):

```bash
flutter run --target lib/main_dev.dart
```

## Contribution Opportunities

Want to contribute? The easiest way is to open an issue using one of the templates:

- Report a bug: [Bug report template](https://github.com/csertant/fama/issues/new?template=bug_report.yml)
- Suggest an improvement: [Feature request template](https://github.com/csertant/fama/issues/new?template=feature_request.yml)
- Browse all options: [Open issue templates](https://github.com/csertant/fama/issues/new/choose)

Before opening a new issue, please search existing issues to avoid duplicates.

## Contact

For direct contact, email:

- nosebitestudios@gmail.com
