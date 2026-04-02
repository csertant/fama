// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => AppSettings(
  languageCode: json['languageCode'] as String? ?? 'hu',
  theme:
      $enumDecodeNullable(_$ThemeModeEnumMap, json['theme']) ??
      ThemeMode.system,
);

Map<String, dynamic> _$AppSettingsToJson(AppSettings instance) =>
    <String, dynamic>{
      'languageCode': instance.languageCode,
      'theme': _$ThemeModeEnumMap[instance.theme],
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
