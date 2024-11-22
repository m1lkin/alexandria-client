// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModel _$PostModelFromJson(Map<String, dynamic> json) => PostModel(
      id: (json['_id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      author: json['author'] as String,
      authorName: json['author_name'] as String,
      keywords:
          (json['keywords'] as List<dynamic>).map((e) => e as String).toList(),
      files: (json['files'] as List<dynamic>)
          .map((e) => FileInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      rating: (json['rating'] as num).toInt(),
      uploadTime: DateTime.parse(json['upload_time'] as String),
      rate: $enumDecode(_$VoteStatusEnumMap, json['rate']),
    );

Map<String, dynamic> _$PostModelToJson(PostModel instance) => <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'author': instance.author,
      'author_name': instance.authorName,
      'keywords': instance.keywords,
      'files': instance.files,
      'rating': instance.rating,
      'upload_time': instance.uploadTime.toIso8601String(),
      'rate': _$VoteStatusEnumMap[instance.rate]!,
    };

const _$VoteStatusEnumMap = {
  VoteStatus.up: 'Up',
  VoteStatus.down: 'Down',
  VoteStatus.none: 'None',
};

CreatePost _$CreatePostFromJson(Map<String, dynamic> json) => CreatePost(
      title: json['title'] as String,
      description: json['description'] as String,
      keywords:
          (json['keywords'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$CreatePostToJson(CreatePost instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'keywords': instance.keywords,
    };

FileInfo _$FileInfoFromJson(Map<String, dynamic> json) => FileInfo(
      filename: json['filename'] as String,
      size: (json['size'] as num).toInt(),
    );

Map<String, dynamic> _$FileInfoToJson(FileInfo instance) => <String, dynamic>{
      'filename': instance.filename,
      'size': instance.size,
    };
