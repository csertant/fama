// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Article _$ArticleFromJson(Map<String, dynamic> json) => Article(
  id: json['id'] as String,
  profileId: json['profileId'] as String,
  sourceId: json['sourceId'] as String,
  sourceTitle: json['sourceTitle'] as String,
  title: json['title'] as String,
  url: json['url'] as String,
  description: json['description'] as String?,
  author: json['author'] as String?,
  publishedAt: DateTime.parse(json['publishedAt'] as String),
  lastSyncedAt: json['lastSyncedAt'] == null
      ? null
      : DateTime.parse(json['lastSyncedAt'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  isRead: json['isRead'] as bool? ?? false,
);

Map<String, dynamic> _$ArticleToJson(Article instance) => <String, dynamic>{
  'id': instance.id,
  'profileId': instance.profileId,
  'sourceId': instance.sourceId,
  'sourceTitle': instance.sourceTitle,
  'title': instance.title,
  'url': instance.url,
  'description': instance.description,
  'author': instance.author,
  'publishedAt': instance.publishedAt.toIso8601String(),
  'lastSyncedAt': instance.lastSyncedAt?.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'isRead': instance.isRead,
};
