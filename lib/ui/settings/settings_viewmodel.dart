import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/repositories/settings/settings_repository.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../models/app_settings.dart';
import '../../utils/utils.dart';

class SettingsViewModel extends ChangeNotifier {
  SettingsViewModel({required SettingsRepository settingsRepository})
    : _settingsRepository = settingsRepository {
    load = Command0(_load);
    updateTheme = Command1(_updateTheme);
    updateLanguage = Command1(_updateLanguage);
    _settingsRepository.addListener(notifyListeners);
    unawaited(load.execute());
  }

  final SettingsRepository _settingsRepository;

  late Command0<void> load;
  late Command1<void, ThemeMode> updateTheme;
  late Command1<void, String> updateLanguage;

  AppSettings get appSettings => _settingsRepository.appSettings;
  ThemeMode get theme => appSettings.theme;
  String get language => appSettings.languageCode;

  List<Locale> get availableLocales => AppLocalizations.supportedLocales;
  List<ThemeMode> get availableThemes => ThemeMode.values;

  Future<Result<void>> _load() async {
    try {
      return await _settingsRepository.load();
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _updateTheme(final ThemeMode theme) {
    return _settingsRepository.updateTheme(theme: theme);
  }

  Future<Result<void>> _updateLanguage(final String languageCode) {
    return _settingsRepository.updateLanguage(languageCode: languageCode);
  }

  @override
  void dispose() {
    _settingsRepository.removeListener(notifyListeners);
    super.dispose();
  }
}
