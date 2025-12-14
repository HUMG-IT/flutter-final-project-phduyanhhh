import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/repositories/post_repository_impl.dart';

class CreatePostDialog extends StatefulWidget {
  final int userId;
  final VoidCallback onCreated;

  const CreatePostDialog({
    super.key,
    required this.userId,
    required this.onCreated,
  });

  @override
  State<CreatePostDialog> createState() => _CreatePostDialogState();
}

class _CreatePostDialogState extends State<CreatePostDialog> {
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();

  final List<String> _imagesBase64 = [];

  bool _loading = false;

  // ================= IMAGE PICK =================
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    final bytes = await image.readAsBytes();
    final base64Image = base64Encode(bytes);

    setState(() {
      _imagesBase64.add(base64Image);
    });
  }

  // ================= SUBMIT =================
  Future<void> _submit() async {
    if (_loading) return;

    setState(() => _loading = true);

    final postRepo = context.read<PostRepositoryImpl>();

    await postRepo.createPost(
      title: _titleCtrl.text,
      content: _contentCtrl.text,
      authorId: widget.userId,
      images: _imagesBase64,
    );

    widget.onCreated(); // ✅ báo cho PostPage reload
    Navigator.pop(context); // ✅ POP DUY NHẤT 1 LẦN
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Post'),

      // ✅ FIX CỨNG SIZE – QUAN TRỌNG
      content: SizedBox(
        width: 420,
        height: 520,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TITLE
              TextField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 12),

              // CONTENT
              TextField(
                controller: _contentCtrl,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Content'),
              ),
              const SizedBox(height: 16),

              // PICK IMAGE
              TextButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Add image'),
              ),
              const SizedBox(height: 12),

              // IMAGE PREVIEW
              if (_imagesBase64.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _imagesBase64.map((img) {
                    return Image.memory(
                      Uint8List.fromList(base64Decode(img)),
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),

      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _loading ? null : _submit,
          child: _loading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Create'),
        ),
      ],
    );
  }
}
