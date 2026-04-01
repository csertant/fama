import 'dart:async';

import 'package:flutter/material.dart';

import '../../../utils/result.dart';
import '../../services/shared_preferences_service/app_settings.dart';
import '../../services/shared_preferences_service/shared_preferences_service.dart';
import 'settings_repository.dart';

class SettingsRepositoryLocal extends SettingsRepository {
  SettingsRepositoryLocal({
    required final SharedPreferencesService sharedPreferencesService,
  }) : _sharedPreferencesService = sharedPreferencesService {
    unawaited(load());
  }

  static final AppSettings _defaultSettings = AppSettings(
    languageCode: AppLanguage.hungarian,
    theme: ThemeMode.system,
  );

  final SharedPreferencesService _sharedPreferencesService;
  AppSettings _appSettings = _defaultSettings;
  bool _isLoading = false;

  @override
  AppSettings get appSettings => _appSettings;

  @override
  Future<Result<void>> load() async {
    if (_isLoading) {
      return const Result.ok(null);
    }
    _isLoading = true;
    try {
      final appSettingsResult = await _getAppSettingsOrDefault();
      switch (appSettingsResult) {
        case Ok<AppSettings>():
          _appSettings = appSettingsResult.value;
          notifyListeners();
          return const Result.ok(null);
        case Error<AppSettings>():
          return appSettingsResult;
      }
    } finally {
      _isLoading = false;
    }
  }

  @override
  Future<Result<AppSettings>> getAppSettings() async {
    final loadResult = await load();
    switch (loadResult) {
      case Ok<void>():
        return Result.ok(_appSettings);
      case Error<void>():
        return Result.error(loadResult.error);
    }
  }

  @override
  Future<Result<void>> updateLanguage({
    required final String languageCode,
  }) async {
    final loadResult = await load();
    switch (loadResult) {
      case Ok<void>():
        final updatedAppSettings = _appSettings.copyWith(
          languageCode: languageCode,
        );
        final saveResult = await _saveAppSettings(updatedAppSettings);
        switch (saveResult) {
          case Ok<void>():
            _appSettings = updatedAppSettings;
            notifyListeners();
            return saveResult;
          case Error<void>():
            return saveResult;
        }
      case Error<void>():
        return loadResult;
    }
  }

  @override
  Future<Result<void>> updateTheme({required final ThemeMode theme}) async {
    final loadResult = await load();
    switch (loadResult) {
      case Ok<void>():
        final updatedAppSettings = _appSettings.copyWith(theme: theme);
        final saveResult = await _saveAppSettings(updatedAppSettings);
        switch (saveResult) {
          case Ok<void>():
            _appSettings = updatedAppSettings;
            notifyListeners();
            return saveResult;
          case Error<void>():
            return saveResult;
        }
      case Error<void>():
        return loadResult;
    }
  }

  Future<Result<void>> _saveAppSettings(final AppSettings appSettings) {
    return _sharedPreferencesService.saveAppSettings(appSettings: appSettings);
  }

  Future<Result<AppSettings>> _getAppSettingsOrDefault() async {
    final appSettingsResult = await _sharedPreferencesService.getAppSettings();
    switch (appSettingsResult) {
      case Ok<AppSettings>():
        return appSettingsResult;
      case Error<AppSettings>():
        return Result.ok(_defaultSettings);
    }
  }
}
