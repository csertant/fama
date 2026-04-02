// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SourceRecommendations _$SourceRecommendationsFromJson(
  Map<String, dynamic> json,
) => SourceRecommendations(
  version: (json['version'] as num).toInt(),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  sources: (json['sources'] as List<dynamic>)
      .map((e) => SourceRecommendation.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SourceRecommendationsToJson(
  SourceRecommendations instance,
) => <String, dynamic>{
  'version': instance.version,
  'updated_at': instance.updatedAt.toIso8601String(),
  'sources': instance.sources.map((e) => e.toJson()).toList(),
};

SourceRecommendation _$SourceRecommendationFromJson(
  Map<String, dynamic> json,
) => SourceRecommendation(
  name: json['name'] as String,
  description: json['description'] as String?,
  url: normalizeUrl(json['url'] as String),
  siteUrl: normalizeUrl(json['site_url'] as String),
  language: json['language'] as String,
  country: json['country'] as String,
  category: json['category'] as String,
);

Map<String, dynamic> _$SourceRecommendationToJson(
  SourceRecommendation instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'url': instance.url,
  'site_url': instance.siteUrl,
  'language': instance.language,
  'country': instance.country,
  'category': instance.category,
};
