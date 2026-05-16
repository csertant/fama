import 'package:json_annotation/json_annotation.dart';

import '../../../domain/url_resolver/url_resolver.dart.dart';

part 'models.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class SourceRecommendations {
  SourceRecommendations({
    required this.version,
    required this.updatedAt,
    required this.sources,
  });

  factory SourceRecommendations.fromJson(final Map<String, dynamic> json) =>
      _$SourceRecommendationsFromJson(json);

  final int version;
  final DateTime updatedAt;
  final List<SourceRecommendation> sources;

  Map<String, dynamic> toJson() => _$SourceRecommendationsToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class SourceRecommendation {
  SourceRecommendation({
    required this.name,
    this.description,
    required this.url,
    required this.siteUrl,
    required this.language,
    required this.country,
    required this.category,
    required this.genre,
  });

  factory SourceRecommendation.fromJson(final Map<String, dynamic> json) =>
      _$SourceRecommendationFromJson(json);

  final String name;
  final String? description;
  @JsonKey(fromJson: UrlResolver.cleanUrl)
  final String url;
  @JsonKey(fromJson: UrlResolver.cleanUrl)
  final String siteUrl;
  final String language;
  final String country;
  final String category;
  final String genre;

  Map<String, dynamic> toJson() => _$SourceRecommendationToJson(this);
}
