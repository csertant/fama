import 'package:json_annotation/json_annotation.dart';

import '../utils/types.dart';

part 'article.g.dart';

@JsonSerializable()
class Article {
  Article({
    required this.id,
    required this.profileId,
    required this.sourceId,
    required this.sourceTitle,
    required this.title,
    required this.url,
    this.description,
    this.author,
    required this.publishedAt,
    this.lastSyncedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isRead = false,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Article.fromJson(final Map<String, dynamic> json) =>
      _$ArticleFromJson(json);

  final ArticleId id;
  final ProfileId profileId;
  final SourceId sourceId;
  final String sourceTitle;
  final String title;
  final String url;
  final String? description;
  final String? author;
  final DateTime publishedAt;
  DateTime? lastSyncedAt;
  DateTime createdAt;
  DateTime updatedAt;
  bool isRead;

  Map<String, dynamic> toJson() => _$ArticleToJson(this);
}
