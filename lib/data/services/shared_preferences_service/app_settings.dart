import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

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
  AppSettings({required this.languageCode, required this.theme});

  factory AppSettings.fromJson(final JsonMap json) =>
      _$AppSettingsFromJson(json);

  @JsonKey(defaultValue: AppLanguage.hungarian)
  final String languageCode;

  @JsonKey(defaultValue: ThemeMode.system)
  final ThemeMode theme;

  AppSettings copyWith({final String? languageCode, final ThemeMode? theme}) {
    return AppSettings(
      languageCode: languageCode ?? this.languageCode,
      theme: theme ?? this.theme,
    );
  }

  JsonMap toJson() => _$AppSettingsToJson(this);
}
