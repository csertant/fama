import '../../../models/app_settings.dart';
import '../../../utils/result.dart';
import '../../services/shared_preferences_service.dart';
import 'settings_repository.dart';

class SettingsRepositoryLocal implements SettingsRepository {
  SettingsRepositoryLocal({
    required final SharedPreferencesService sharedPreferencesService,
  }) : _sharedPreferencesService = sharedPreferencesService;

  final SharedPreferencesService _sharedPreferencesService;

  @override
  Future<Result<AppSettings>> getAppSettings() {
    return _getAppSettingsOrDefault();
  }

  @override
  Future<Result<void>> updateLanguage(final String languageCode) async {
    final currentAppSettingsResult = await _getAppSettingsOrDefault();
    switch (currentAppSettingsResult) {
      case Ok<AppSettings>():
        final updatedAppSettings = currentAppSettingsResult.value.copyWith(
          languageCode: languageCode,
        );
        return _saveAppSettings(updatedAppSettings);
      case Error<AppSettings>():
        return currentAppSettingsResult;
    }
  }

  @override
  Future<Result<void>> updateTheme(final AppTheme theme) async {
    final currentAppSettingsResult = await _getAppSettingsOrDefault();
    switch (currentAppSettingsResult) {
      case Ok<AppSettings>():
        final updatedAppSettings = currentAppSettingsResult.value.copyWith(
          theme: theme,
        );
        return _saveAppSettings(updatedAppSettings);
      case Error<AppSettings>():
        return currentAppSettingsResult;
    }
  }

  Future<Result<void>> _saveAppSettings(final AppSettings appSettings) {
    return _sharedPreferencesService.saveAppSettings(appSettings);
  }

  Future<Result<AppSettings>> _getAppSettingsOrDefault() async {
    final appSettingsResult = await _sharedPreferencesService.getAppSettings();
    switch (appSettingsResult) {
      case Ok<AppSettings>():
        return appSettingsResult;
      case Error<AppSettings>():
        return Result.ok(
          AppSettings(
            languageCode: AppLanguage.hungarian,
            theme: AppTheme.light,
          ),
        );
    }
  }
}
