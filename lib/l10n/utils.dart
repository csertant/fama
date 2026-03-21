import 'package:flutter/material.dart';

import '../models/app_settings.dart';
import 'generated/app_localizations.dart';

String mapThemeModeToString(final BuildContext context, final ThemeMode theme) {
  final localizations = AppLocalizations.of(context)!;
  switch (theme) {
    case ThemeMode.light:
      return localizations.settingsThemeOptionLight;
    case ThemeMode.dark:
      return localizations.settingsThemeOptionDark;
    case ThemeMode.system:
      return localizations.settingsThemeOptionSystem;
  }
}

String mapLanguageCodeToString(
  final BuildContext context,
  final String languageCode,
) {
  final localizations = AppLocalizations.of(context)!;
  switch (languageCode) {
    case AppLanguage.hungarian:
      return localizations.settingsLanguageOptionHungarian;
    case AppLanguage.english:
      return localizations.settingsLanguageOptionEnglish;
    default:
      return localizations.settingsLanguageOptionUnknown;
  }
}
