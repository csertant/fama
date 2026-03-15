import 'package:json_annotation/json_annotation.dart';

import '../utils/types.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile {
  Profile({
    required this.id,
    required this.name,
    required this.displayName,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Profile.fromJson(final Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  final ProfileId id;
  final String name;
  final String displayName;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
