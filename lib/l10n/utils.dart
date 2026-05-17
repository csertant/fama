import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/services/shared_preferences_service/app_settings.dart';
import '../domain/url_resolver/url_strategies.dart';
import '../ui/core/widgets/custom_filter.dart';
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
    case AppLanguage.french:
      return localizations.settingsLanguageOptionFrench;
    case AppLanguage.german:
      return localizations.settingsLanguageOptionGerman;
    case AppLanguage.spanish:
      return localizations.settingsLanguageOptionSpanish;
    case AppLanguage.italian:
      return localizations.settingsLanguageOptionItalian;
    default:
      return localizations.settingsLanguageOptionUnknown;
  }
}

String mapDurationToString(
  final BuildContext context,
  final Duration duration,
) {
  final localizations = AppLocalizations.of(context)!;
  if (duration.inHours == FilterDuration.hour.inHours) {
    return localizations.filtersDurationOptionHour;
  } else if (duration.inHours == FilterDuration.sixHours.inHours) {
    return localizations.filtersDurationOptionSixHours;
  } else if (duration.inDays == FilterDuration.day.inDays) {
    return localizations.filtersDurationOptionDay;
  } else if (duration.inDays == FilterDuration.threeDays.inDays) {
    return localizations.filtersDurationOptionThreeDays;
  } else if (duration.inDays == FilterDuration.week.inDays) {
    return localizations.filtersDurationOptionWeek;
  } else if (duration.inDays == FilterDuration.month.inDays) {
    return localizations.filtersDurationOptionMonth;
  } else {
    return localizations.filtersDurationOptionYear;
  }
}

String mapCategoryToString(final BuildContext context, final String category) {
  final localizations = AppLocalizations.of(context)!;
  switch (category) {
    case 'general':
      return localizations.filtersCategoryOptionGeneral;
    case 'economy':
      return localizations.filtersCategoryOptionEconomy;
    case 'media':
      return localizations.filtersCategoryOptionMedia;
    case 'science':
      return localizations.filtersCategoryOptionScience;
    default:
      return localizations.filtersCategoryOptionUnknown;
  }
}

String mapGenreToString(final BuildContext context, final String genre) {
  final localizations = AppLocalizations.of(context)!;
  switch (genre) {
    case 'general':
      return localizations.filtersGenreOptionGeneral;
    case 'longform':
      return localizations.filtersGenreOptionLongform;
    case 'investigative':
      return localizations.filtersGenreOptionInvestigative;
    case 'opinion':
      return localizations.filtersGenreOptionOpinion;
    case 'comic':
      return localizations.filtersGenreOptionComic;
    case 'podcast':
      return localizations.filtersGenreOptionPodcast;
    case 'video':
      return localizations.filtersGenreOptionVideo;
    default:
      return localizations.filtersGenreOptionUnknown;
  }
}

String mapPlatformToHintTextString(
  final BuildContext context,
  final Platform platform,
) {
  final localizations = AppLocalizations.of(context)!;
  switch (platform) {
    case Platform.bluesky:
      return localizations.exploreAddBlueskyHintText;
    case Platform.github:
      return localizations.exploreAddGithubHintText;
    case Platform.mastodon:
      return localizations.exploreAddMastodonHintText;
    case Platform.medium:
      return localizations.exploreAddMediumHintText;
    case Platform.pinterest:
      return localizations.exploreAddPinterestHintText;
    case Platform.reddit:
      return localizations.exploreAddRedditHintText;
    case Platform.stackoverflow:
      return localizations.exploreAddStackOverflowHintText;
    case Platform.substack:
      return localizations.exploreAddSubstackHintText;
    case Platform.tumblr:
      return localizations.exploreAddTumblrHintText;
    case Platform.other:
      return localizations.exploreAddCustomSourceSubtitle;
  }
}

String formatBytesAsFileSize(final int bytes) {
  if (bytes <= 0) {
    return '0 B';
  }
  const suffixes = ['B', 'KB', 'MB', 'GB'];
  final i = (math.log(bytes) / math.log(1024)).floor();
  return '${(bytes / math.pow(1024, i)).toStringAsFixed(2)} ${suffixes[i]}';
}
