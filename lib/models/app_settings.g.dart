// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => AppSettings(
  languageCode: json['languageCode'] as String? ?? 'hu',
  theme:
      $enumDecodeNullable(_$AppThemeEnumMap, json['theme']) ?? AppTheme.system,
);

Map<String, dynamic> _$AppSettingsToJson(AppSettings instance) =>
    <String, dynamic>{
      'languageCode': instance.languageCode,
      'theme': _$AppThemeEnumMap[instance.theme]!,
    };

const _$AppThemeEnumMap = {
  AppTheme.light: 'light',
  AppTheme.dark: 'dark',
  AppTheme.system: 'system',
};
