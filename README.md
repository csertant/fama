# fama

fama is a cross-platform news reader built with Flutter. It helps users discover RSS sources, build a personalized feed, save articles for later, and keep reading across devices and platforms.

![GitHub Release](https://img.shields.io/github/v/release/csertant/fama)
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

## Issues and Contact

If you find a bug, want to request a feature, or have a question:

1. Open the repository Issues tab.
2. Create a new issue with:
	- A clear title
	- Steps to reproduce (for bugs)
	- Expected vs. actual behavior
	- Device/platform details (for example: Android, iOS, Web)

For direct contact, email:

- nosebitestudios@gmail.com