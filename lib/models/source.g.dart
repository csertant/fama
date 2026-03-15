// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Source _$SourceFromJson(Map<String, dynamic> json) => Source(
  id: json['id'] as String,
  title: json['title'] as String,
  url: json['url'] as String,
  profileId: json['profileId'] as String,
  description: json['description'] as String?,
  isActive: json['isActive'] as bool? ?? true,
  failureCount: (json['failureCount'] as num?)?.toInt() ?? 0,
  lastSyncedAt: json['lastSyncedAt'] == null
      ? null
      : DateTime.parse(json['lastSyncedAt'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$SourceToJson(Source instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'url': instance.url,
  'description': instance.description,
  'isActive': instance.isActive,
  'failureCount': instance.failureCount,
  'lastSyncedAt': instance.lastSyncedAt?.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'profileId': instance.profileId,
};
