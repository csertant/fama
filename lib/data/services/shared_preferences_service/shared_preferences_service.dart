import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/utils.dart';
import 'app_settings.dart';

class SharedPreferencesService {
  final _appSettingsKey = 'APP_SETTINGS';
  final _sharedPreferences = SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(),
  );

  Future<Result<AppSettings>> getAppSettings() async {
    try {
      final sharedPreferences = await _sharedPreferences;
      final result = sharedPreferences.getString(_appSettingsKey);
      if (result != null) {
        return Result.ok(AppSettings.fromJson(json.decode(result) as JsonMap));
      }
      return Result.error(Exception('App settings not found'));
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> saveAppSettings({
    required final AppSettings appSettings,
  }) async {
    try {
      final sharedPreferences = await _sharedPreferences;
      await sharedPreferences.setString(
        _appSettingsKey,
        json.encode(appSettings.toJson()),
      );
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
