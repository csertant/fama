import 'package:json_annotation/json_annotation.dart';

import '../utils/types.dart';

part 'source.g.dart';

@JsonSerializable()
class Source {
  Source({
    required this.id,
    required this.title,
    required this.url,
    required this.profileId,
    this.description,
    this.isActive = true,
    this.failureCount = 0,
    this.lastSyncedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Source.fromJson(final Map<String, dynamic> json) =>
      _$SourceFromJson(json);

  final SourceId id;
  final String title;
  final String url;
  final String? description;
  bool isActive;
  int failureCount;
  DateTime? lastSyncedAt;
  DateTime createdAt;
  DateTime updatedAt;
  final ProfileId profileId;

  Map<String, dynamic> toJson() => _$SourceToJson(this);
}
