import 'package:json_annotation/json_annotation.dart';

import '../utils/types.dart';

part 'session.g.dart';

@JsonSerializable()
class Session {
  Session({required this.profileId});

  factory Session.fromJson(final Map<String, dynamic> json) =>
      _$SessionFromJson(json);

  final ProfileId profileId;

  Map<String, dynamic> toJson() => _$SessionToJson(this);
}
