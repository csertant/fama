# Changelog

All notable changes to this project will be documented in this file.

## [1.3.0] - 2026-05-16

### Added

- More robust sanitizer for processing feed data.
- Snackbar feedback for trash actions.
- Auto transform URLs for supported sources into feed URLs when subscribing.

### Miscellaneous
- Migrate to Swift Package Manager for iOS and macOS dependencies for better integration and maintenance.

## [1.2.0] - 2026-04-26

### Added

- Support more categories and genres for source recommendations.

### Fixed

- Support for source recommendation categories.
- Small adjustments for translations.
- Appbar elevation on scroll for better visual consistency across platforms.

## [1.1.0] - 2026-04-18

### Added

- Responsive design improvements for better usability on various screen sizes and orientations.

### Fixed

- App display name updated to 'fáma' across all platforms for consistency.
- macOS entitlements file to allow network access for fetching feed data.

## [1.0.0] - 2026-04-15

### Added

- Immediate actions on empty states in the app, such as prompts to add sources or explore content when no items are available.
- Free up space section now shows database size.

## [1.0.0-rc.3] - 2026-04-14

### Added

- A contact section to the settings page with email address for user feedback and contributions.
- Remove old articles from the app to free up storage space.

## [1.0.0-rc.2] - 2026-04-13

### Fixed

- AndroidManifest.xml now includes INTERNET permission for network access.

## [1.0.0-rc.1] - 2026-04-10

### Added

- Initial public release.
- Cross-platform Flutter app setup for Android, iOS, Linux, macOS, web, and Windows.
- Core app modules for feed, explore, sources, saved items, and settings.
- Localization support with English and Hungarian resources.
