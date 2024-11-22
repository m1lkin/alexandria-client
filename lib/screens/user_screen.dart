import 'package:alexandria/models/post.dart';
import 'package:alexandria/services/post_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      children: [
        SizedBox(height: 25,),
        Column(
          children: [Column(
            children: [
              Icon(Icons.account_circle_rounded, size: 100,),
              Text("m1lkin", style: Theme.of(context).textTheme.displayMedium,)
            ],
          ),
          ],
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextButton (
              onPressed: () {
                print("hi");
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => CreationPost(),
                ));
              }, 
              style: TextButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                minimumSize: Size(500, 100),
                textStyle: Theme.of(context).textTheme.headlineMedium,
                
              ),
              child: Text("Создать новую запись")),
          ),
        ),
      ],
    );
  }
}

class CreationPost extends StatefulWidget {
  @override
  State<CreationPost> createState() => _CreationPostState();
}

class _CreationPostState extends State<CreationPost> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<String> _keywords = [];
  final List<PlatformFile> _attachedFiles = [];
  final _keywordController = TextEditingController();
  final _postService = PostService();

  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: true,
        withData: true,
      );

      if (result != null) {
        setState(() {
          _attachedFiles.addAll(result.files);
        });
      }
    } catch (e) {
      debugPrint('Error picking files: $e');
    }
  }

  void _addKeyword() {
    if (_keywordController.text.isNotEmpty) {
      setState(() {
        _keywords.add(_keywordController.text);
        _keywordController.clear();
      });
    }
  }

  void _removeKeyword(String keyword) {
    setState(() {
      _keywords.remove(keyword);
    });
  }

  void _removeFile(int index) {
    setState(() {
      _attachedFiles.removeAt(index);
    });
  }

  Future<void> _send() async {
                    if (_formKey.currentState!.validate()) {
                      // TODO: Обработка отправки формы
                      final postData = CreatePost(
                        title: _titleController.text, 
                        description: _descriptionController.text, 
                        keywords: _keywords
                      );
                      var post = await _postService.createPost(postData);
                      await _postService.uploadFiles(_attachedFiles, post);
                    }
                  }

  IconData _getFileIcon(String? fileUrl) {
    switch (fileUrl?.toLowerCase()) {
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
        return Icons.image;
      case 'mp4':
      case 'avi':
      case 'mov':
        return Icons.video_file;
      default:
        return Icons.insert_drive_file;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Создать пост'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Заголовок',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите заголовок';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Описание
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Описание',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите описание';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Прикрепленные файлы
              Text('Прикрепленные файлы:', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ..._attachedFiles.asMap().entries.map((entry) {
                    final file = entry.value;
                    return Container(
                      width: 200,
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        leading: Icon(
                          _getFileIcon(file.extension),
                        ),
                        title: Text(
                          file.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          '${(file.size / 1024).toStringAsFixed(2)} KB',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => _removeFile(entry.key),
                        ),
                      ),
                    );
                  }),
                  ElevatedButton.icon(
                    onPressed: _pickFiles,
                    icon: const Icon(Icons.attach_file),
                    label: const Text('Добавить файлы'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Ключевые слова
              Text('Ключевые слова:', style: Theme.of(context).textTheme.titleMedium),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _keywordController,
                      decoration: const InputDecoration(
                        hintText: 'Введите ключевое слово',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _addKeyword,
                    child: const Text('Добавить'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _keywords.map((keyword) {
                  return Chip(
                    label: Text(keyword),
                    onDeleted: () => _removeKeyword(keyword),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Кнопка отправки
              Center(
                child: ElevatedButton(
                  onPressed: _send,
                  child: const Text('Создать пост'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _keywordController.dispose();
    super.dispose();
  }
}
