import 'dart:convert';
import 'dart:io';

import 'package:alexandria/models/post.dart';
import 'package:alexandria/services/post_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:intl/intl.dart';

class PostsScreen extends StatelessWidget {
  final List<PostModel> posts;
  final PostService _postService = PostService();

  PostsScreen({super.key, required this.posts});
  Future<void> _downloadFile(String file, int post) async {
    // TODO
    if (Platform.isAndroid) {
      print("download");
    final taskId = await FlutterDownloader.enqueue(
      url: "http://127.0.0.1:3000/posts/$post/files/${utf8.decode(file.codeUnits)}", 
      savedDir: "/storage/emulated/0/Download",
      fileName: utf8.decode(file.codeUnits),
      openFileFromNotification: true,
      saveInPublicStorage: true,
    );
    } 
  }

  Future<void> _ratePost(int post, VoteStatus vote) async {
    await _postService.updateVote(post, vote);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [for (var i in posts) PostCard(
              post: i, 
              onVoteChanged: (vote, post) {
                _ratePost(post, vote);
              }, 
              onFileDownload: (file, post) {
                _downloadFile(file, post);
              }
            )]
            ,
          )
        );
  }
}

class PostCard extends StatefulWidget {
  final PostModel post;
  final Function(VoteStatus, int) onVoteChanged;
  final Function(String, int) onFileDownload;

  const PostCard({
    super.key,
    required this.post,
    required this.onVoteChanged,
    required this.onFileDownload,
  });

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  Widget _buildVoteButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            Icons.arrow_upward,
            color: widget.post.rate == VoteStatus.up 
                ? Colors.orange 
                : Colors.grey,
          ),
          onPressed: () {
            setState(() {
              if (widget.post.rate == VoteStatus.up) {
                // Отмена голоса вверх
                widget.post.rating--;
                widget.post.rate = VoteStatus.none;
              } else if (widget.post.rate == VoteStatus.down) {
                // Смена голоса с вниз на вверх
                widget.post.rating += 2;
                widget.post.rate = VoteStatus.up;
              } else {
                // Новый голос вверх
                widget.post.rating++;
                widget.post.rate = VoteStatus.up;
              }
              widget.onVoteChanged(widget.post.rate, widget.post.id);
            });
          },
        ),
        Container(
          constraints: const BoxConstraints(minWidth: 40),
          child: Text(
            widget.post.rating.toString(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: widget.post.rate == VoteStatus.up 
                  ? Colors.orange 
                  : widget.post.rate == VoteStatus.down 
                      ? Colors.blue 
                      : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.arrow_downward,
            color: widget.post.rate == VoteStatus.down 
                ? Colors.blue 
                : Colors.grey,
          ),
          onPressed: () {
            setState(() {
              if (widget.post.rate == VoteStatus.down) {
                // Отмена голоса вниз
                widget.post.rating++;
                widget.post.rate = VoteStatus.none;
              } else if (widget.post.rate == VoteStatus.up) {
                // Смена голоса с вверх на вниз
                widget.post.rating -= 2;
                widget.post.rate = VoteStatus.down;
              } else {
                // Новый голос вниз
                widget.post.rating--;
                widget.post.rate = VoteStatus.down;
              }
              widget.onVoteChanged(widget.post.rate, widget.post.id);
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 600;
        
        return Card(
          elevation: 4,
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: isNarrow 
                ? _buildNarrowLayout() 
                : _buildWideLayout(),
          ),
        );
      },
    );
  }

  Widget _buildNarrowLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 12),
        _buildDescription(),
        const SizedBox(height: 12),
        _buildFiles(),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(flex: 1, child: _buildVoteButtons()),
            Expanded(flex: 1, child: _buildFooter()),
          ],
        ),
      ],
    );
  }

  Widget _buildWideLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVoteButtons(),
            const SizedBox(width: 16),
            Expanded(
              flex: 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 12),
                  _buildDescription(),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 3,
              child: _buildFiles(),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildFooter(),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          utf8.decode(widget.post.title.codeUnits),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 4),
        Text(
          DateFormat('dd.MM.yyyy HH:mm').format(widget.post.uploadTime),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      utf8.decode(widget.post.description.codeUnits),
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  Widget _buildFiles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Прикрепленные файлы:',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ...widget.post.files.map((file) => _buildFileItem(file)),
      ],
    );
  }

  Widget _buildFileItem(FileInfo file) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => widget.onFileDownload(file.filename, widget.post.id),
        child: Row(
          children: [
            Icon(widget.post.getFileIcon(file.filename)),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    utf8.decode(file.filename.codeUnits),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    "${file.size}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: () => widget.onFileDownload(file.filename, widget.post.id),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Icon(
          Icons.person_outline,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          'Автор: ${utf8.decode(widget.post.authorName.codeUnits)}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}