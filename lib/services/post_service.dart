import 'dart:convert';
import 'package:alexandria/models/post.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class PostService {
  static const String baseUrl = 'http://127.0.0.1:3000'; // Замените на ваш URL
  static const String token = ""; //user token
  final dio = Dio();

  Future<List<PostModel>> getPosts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_posts?posts=0&keywords='),
        headers: {
          // Добавьте заголовки авторизации, если требуется
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => PostModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load posts: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to load: $e');
    }
  }

  Future<bool> updateVote(int postId, VoteStatus vote) async {
    try {
      var vt = switch (vote) {
        VoteStatus.up => "Up",
        VoteStatus.down => "Down",
        VoteStatus.none => "None"
      };

      final response = await http.post(
        Uri.parse('$baseUrl/rate_post'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'post': postId,
          'rating': vt,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to update vote: $e');
    }
  }

  Future<int> createPost(CreatePost post) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create_post'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(post.toJson()),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as int;
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception('Failed to update vote: $e');
    }
  }

  Future<void> uploadFiles(List<PlatformFile> files, int post) async {
    var formData = FormData();

    for (var file in files) {
      formData.files.addAll([
        MapEntry(
          'file',
          await MultipartFile.fromBytes(
            file.bytes!,
            filename: file.name,
          ))
      ]);
    }

    final response = await dio.post(
      "$baseUrl/posts/$post/upload",
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token'
        },
        sendTimeout: const Duration(minutes: 2),
        receiveTimeout: const Duration(minutes: 2),
      )
    );

    if (response.statusCode == 200) {
      print('Фвйлы звгружены');
      print(response);
    }
  }
}