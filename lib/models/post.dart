import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class PostModel {
  @JsonKey(name: '_id')
  final int id;
  final String title;
  final String description;
  final String author;
  @JsonKey(name: 'author_name')
  final String authorName;
  final List<String> keywords;
  final List<FileInfo> files;
  int rating;
  @JsonKey(name: 'upload_time')
  final DateTime uploadTime;
  VoteStatus rate;

  PostModel({
    required this.id,
    required this.title,
    required this.description,
    required this.author,
    required this.authorName,
    required this.keywords,
    required this.files,
    required this.rating,
    required this.uploadTime,
    required this.rate,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);

  String getFileNameFromUrl(String fileUrl) {
    return fileUrl.split('/').last;
  }

  String getFileExtension(String fileUrl) {
    return fileUrl.split('.').last.toLowerCase();
  }

  // Получаем иконку для файла на основе его расширения
  IconData getFileIcon(String fileUrl) {
    final extension = getFileExtension(fileUrl);
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'svg':
        return Icons.image;
      case 'mp4':
      case 'avi':
      case 'mov':
        return Icons.video_file;
      default:
        return Icons.insert_drive_file;
    }
  }
}

@JsonSerializable()
class CreatePost {
  final String title;
  final String description;
  final List<String> keywords;

  CreatePost({
    required this.title,
    required this.description,
    required this.keywords
  });

  Map toJson() => _$CreatePostToJson(this);
}

@JsonSerializable()
class FileInfo {
  String filename;
  int size;

  FileInfo({
    required this.filename,
    required this.size
  });

  factory FileInfo.fromJson(Map<String, dynamic> json) => _$FileInfoFromJson(json);
}

enum VoteStatus { up, down, none }