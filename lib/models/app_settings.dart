import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_settings.g.dart';

class AppLanguage {
  static const String hungarian = 'hu';
  static const String english = 'en';
}

@JsonSerializable()
class AppSettings {
  AppSettings({required this.languageCode, required this.theme});

  factory AppSettings.fromJson(final Map<String, dynamic> json) =>
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

  Map<String, dynamic> toJson() => _$AppSettingsToJson(this);
}
