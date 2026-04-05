import 'dart:async';

import 'package:flutter/material.dart';

import '../../../utils/utils.dart';
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

  @override
  AppSettings get appSettings => _appSettings;

  @override
  Future<Result<void>> load() async {
    final appSettingsResult = await _getAppSettingsOrDefault();
    switch (appSettingsResult) {
      case Ok<AppSettings>():
        _appSettings = appSettingsResult.value;
        notifyListeners();
        return const Result.ok(null);
      case Error<AppSettings>(error: final error):
        return Result.error(error);
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
        final saveResult = await _sharedPreferencesService.saveAppSettings(
          appSettings: updatedAppSettings,
        );
        if (saveResult is Ok<void>) {
          _appSettings = updatedAppSettings;
          notifyListeners();
        }
        return saveResult;
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
        final saveResult = await _sharedPreferencesService.saveAppSettings(
          appSettings: updatedAppSettings,
        );
        if (saveResult is Ok<void>) {
          _appSettings = updatedAppSettings;
          notifyListeners();
        }
        return saveResult;
      case Error<void>():
        return loadResult;
    }
  }

  Future<Result<AppSettings>> _getAppSettingsOrDefault() async {
    final appSettingsResult = await _sharedPreferencesService.getAppSettings();
    switch (appSettingsResult) {
      case Ok<AppSettings>():
        return appSettingsResult;
      case Error<AppSettings>(error: final error):
        if (error is DataNotFoundException || error is DataStorageException) {
          return Result.ok(_defaultSettings);
        }
        return Result.error(error);
    }
  }
}
