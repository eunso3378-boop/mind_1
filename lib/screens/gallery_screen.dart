import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class GalleryScreen extends StatefulWidget {
  final String userName;
  const GalleryScreen({super.key, required this.userName});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final List<XFile> selected = await _picker.pickMultiImage();
    if (selected.isNotEmpty) {
      setState(() => _images.addAll(selected));
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F0),
      appBar: AppBar(
        title: Text('${widget.userName} 갤러리'),
        backgroundColor: const Color(0xFFFF9F80),
        actions: [IconButton(onPressed: _pickImage, icon: const Icon(Icons.add_a_photo))],
      ),
      body: _images.isEmpty
          ? const Center(child: Text("기록된 사진이 없습니다."))
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
              itemCount: _images.length,
              itemBuilder: (context, index) => ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(File(_images[index].path), fit: BoxFit.cover),
              ),
            ),
    );
  }
}