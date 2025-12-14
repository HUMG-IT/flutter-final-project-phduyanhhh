import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/post_model.dart';
import '../../data/repositories/post_repository_impl.dart';

class EditPostDialog extends StatefulWidget {
  final int postId;
  final VoidCallback onUpdated;

  const EditPostDialog({
    super.key,
    required this.postId,
    required this.onUpdated,
  });

  @override
  State<EditPostDialog> createState() => _EditPostDialogState();
}

class _EditPostDialogState extends State<EditPostDialog> {
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  List<String> _images = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    // ✅ FIX TREO DIALOG
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPost();
    });
  }

  Future<void> _loadPost() async {
    final repo = context.read<PostRepositoryImpl>();
    final post = await repo.getPostById(widget.postId);

    if (!mounted) return;

    if (post != null) {
      _titleCtrl.text = post.title;
      _contentCtrl.text = post.content;
      _images = List.from(post.images);
    }

    setState(() => _loading = false);
  }

  Future<void> _submit() async {
    await context.read<PostRepositoryImpl>().updatePost(
          widget.postId,
          _titleCtrl.text,
          _contentCtrl.text,
          _images,
        );

    widget.onUpdated();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Chỉnh sửa bài viết'),
      content: _loading
          ? const SizedBox(
              height: 80,
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _titleCtrl,
                    decoration: const InputDecoration(labelText: 'Tiêu đề'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _contentCtrl,
                    decoration: const InputDecoration(labelText: 'Nội dung'),
                    maxLines: 5,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Ảnh: ${_images.length} (chưa làm sửa ảnh)',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Huỷ'),
        ),
        ElevatedButton(
          onPressed: _loading ? null : _submit,
          child: const Text('Lưu'),
        ),
      ],
    );
  }
}
