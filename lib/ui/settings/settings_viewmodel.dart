import 'dart:async';
import 'dart:collection';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

import '../../data/database/database.dart';
import '../../data/managers/session/session_manager.dart';
import '../../data/repositories/article/article_repository.dart';
import '../../data/repositories/profile/profile_repository.dart';
import '../../data/repositories/settings/settings_repository.dart';
import '../../data/services/shared_preferences_service/app_settings.dart';
import '../../l10n/generated/app_localizations.dart';

import '../../utils/utils.dart';

class SettingsViewModel extends ChangeNotifier {
  SettingsViewModel({
    required ProfileRepository profileRepository,
    required ArticleRepository articleRepository,
    required SettingsRepository settingsRepository,
    required SessionManager sessionManager,
  }) : _profileRepository = profileRepository,
       _articleRepository = articleRepository,
       _settingsRepository = settingsRepository,
       _sessionManager = sessionManager {
    load = Command0(_load);
    updateTheme = Command1(_updateTheme);
    updateLanguage = Command1(_updateLanguage);
    createProfile = Command2(_createProfile);
    modifyProfile = Command1(_modifyProfile);
    removeProfile = Command1(_removeProfile);
    switchProfile = Command1(_switchProfile);
    removeArticles = Command3(_removeArticles);

    _settingsRepository.addListener(notifyListeners);
    _sessionManager.addListener(notifyListeners);
    _profilesSubscription = _profileRepository.watchProfiles().listen((
      profiles,
    ) {
      _profiles = profiles;
      notifyListeners();
    });

    unawaited(load.execute());
  }

  final ProfileRepository _profileRepository;
  final ArticleRepository _articleRepository;
  final SettingsRepository _settingsRepository;
  final SessionManager _sessionManager;
  late final StreamSubscription<List<Profile>> _profilesSubscription;

  List<Profile> _profiles = [];
  int _databaseSize = 0;

  late Command0<void> load;
  late Command1<void, ThemeMode> updateTheme;
  late Command1<void, String> updateLanguage;
  late Command2<void, String, String?> createProfile;
  late Command1<void, Profile> modifyProfile;
  late Command1<void, Profile> removeProfile;
  late Command1<void, Profile> switchProfile;
  late Command3<void, bool, bool, DateTime?> removeArticles;

  AppSettings get appSettings => _settingsRepository.appSettings;
  ThemeMode get theme => appSettings.theme;
  String get language => appSettings.languageCode;
  Profile get activeProfile => _profiles.firstWhere(
    (profile) => profile.id == _sessionManager.profileId,
  );
  List<Profile> get profiles => UnmodifiableListView(_profiles);
  List<Locale> get availableLocales => AppLocalizations.supportedLocales;
  List<ThemeMode> get availableThemes => ThemeMode.values;
  int get databaseSize => _databaseSize;

  Future<Result<void>> _load() async {
    try {
      final databaseSizeResult = await _profileRepository.getDatabaseSize();
      if (databaseSizeResult is Ok<int>) {
        _databaseSize = databaseSizeResult.value;
      }
      return await _settingsRepository.load();
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _updateTheme(final ThemeMode theme) {
    return _settingsRepository.updateTheme(theme: theme);
  }

  Future<Result<void>> _updateLanguage(final String languageCode) {
    return _settingsRepository.updateLanguage(languageCode: languageCode);
  }

  Future<Result<void>> _createProfile(
    final String name,
    final String? description,
  ) {
    try {
      return _profileRepository.saveProfile(
        name: name.trim(),
        description: description?.trim(),
      );
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _switchProfile(final Profile profile) {
    return _sessionManager.initializeSession(profileId: profile.id);
  }

  Future<Result<void>> _modifyProfile(final Profile profile) {
    try {
      return _profileRepository.modifyProfile(
        profile: profile.copyWith(
          name: profile.name.trim(),
          description: Value(profile.description?.trim()),
        ),
      );
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _removeProfile(final Profile profile) async {
    try {
      final isActiveProfile = activeProfile.id == profile.id;
      final remainingProfiles = _profiles
          .where((existingProfile) => existingProfile.id != profile.id)
          .toList();
      final removeResult = await _profileRepository.removeProfile(
        profileId: profile.id,
      );
      if (removeResult is Ok<void> &&
          isActiveProfile &&
          remainingProfiles.isNotEmpty) {
        return _sessionManager.initializeSession(
          profileId: remainingProfiles.first.id,
        );
      }
      return removeResult;
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _removeArticles(
    final bool isRead,
    final bool isSaved,
    final DateTime? before,
  ) {
    try {
      return _articleRepository.removeArticles(
        profileId: _sessionManager.profileId!,
        isRead: isRead,
        isSaved: isSaved,
        before: before ?? AppDateTimeUtils.oneMonthAgo(),
      );
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<void> dispose() async {
    _settingsRepository.removeListener(notifyListeners);
    _sessionManager.removeListener(notifyListeners);
    await _profilesSubscription.cancel();
    super.dispose();
  }
}
