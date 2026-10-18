import 'package:json_annotation/json_annotation.dart';
import 'package:material_ui/material_ui.dart';

import '../../../utils/utils.dart';

part 'app_settings.g.dart';

class AppLanguage {
  static const String hungarian = 'hu';
  static const String english = 'en';
  static const String french = 'fr';
  static const String german = 'de';
  static const String spanish = 'es';
  static const String italian = 'it';
}

@JsonSerializable()
class AppSettings {
  AppSettings({required this.languageCode, required this.themeMode});

  factory AppSettings.fromJson(JsonMap json) => _$AppSettingsFromJson(json);

  @JsonKey(defaultValue: AppLanguage.hungarian)
  final String languageCode;

  @JsonKey(defaultValue: ThemeMode.system)
  final ThemeMode themeMode;

  AppSettings copyWith({String? languageCode, ThemeMode? themeMode}) {
    return AppSettings(
      languageCode: languageCode ?? this.languageCode,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  JsonMap toJson() => _$AppSettingsToJson(this);
}
