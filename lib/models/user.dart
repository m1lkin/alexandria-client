import 'package:alexandria/models/post.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(name: "_id")
  final String id;
  final String username;
  final List<int> summary;
  final List<RatedPost> rated;

  UserModel({
    required this.id,
    required this.username,
    required this.summary,
    required this.rated,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}

@JsonSerializable()
class RatedPost {
  final int post;
  final VoteStatus rating;

  RatedPost({
    required this.post,
    required this.rating
  });

  factory RatedPost.fromJson(Map<String, dynamic> json) => _$RatedPostFromJson(json);
}