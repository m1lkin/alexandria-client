import 'package:alexandria/models/post.dart';
import 'package:alexandria/screens/post_screen.dart';
import 'package:alexandria/services/post_service.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _postService = PostService();
  final _searchController = TextEditingController();
  List<String> _keywords = [];
  List<PostModel> posts = [];
  bool isLoaded = false;

  Future<void> _search() async {
    var buf = await _postService.getPosts();;
    setState(() {
      posts = buf;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextFormField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Что вы хотите найти?',
              border: OutlineInputBorder(),
            ),
          ),
          ElevatedButton(
            onPressed: _search,
            child: const Text('Найти'),
          ),
          Flexible(child: PostsScreen(posts: posts))
        ],
      ),
    );
  }
}