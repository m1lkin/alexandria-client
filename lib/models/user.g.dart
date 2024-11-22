// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['_id'] as String,
      username: json['username'] as String,
      summary: (json['summary'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      rated: (json['rated'] as List<dynamic>)
          .map((e) => RatedPost.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      '_id': instance.id,
      'username': instance.username,
      'summary': instance.summary,
      'rated': instance.rated,
    };

RatedPost _$RatedPostFromJson(Map<String, dynamic> json) => RatedPost(
      post: (json['post'] as num).toInt(),
      rating: $enumDecode(_$VoteStatusEnumMap, json['rating']),
    );

Map<String, dynamic> _$RatedPostToJson(RatedPost instance) => <String, dynamic>{
      'post': instance.post,
      'rating': _$VoteStatusEnumMap[instance.rating]!,
    };

const _$VoteStatusEnumMap = {
  VoteStatus.up: 'up',
  VoteStatus.down: 'down',
  VoteStatus.none: 'none',
};
