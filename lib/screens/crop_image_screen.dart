import 'dart:io';
import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';

class CropImageScreen extends StatefulWidget {
  final String imageFilePath;

  const CropImageScreen({
    super.key,
    required this.imageFilePath,
  });

  @override
  State<CropImageScreen> createState() => _CropImageScreenState();
}

class _CropImageScreenState extends State<CropImageScreen> {
  final _controller = CropController();

  bool _isProcessing = false;
  bool _loadingImage = false;

  set isProcessing(bool value) {
    setState(() {
      _isProcessing = value;
    });
  }

  Uint8List? imageData;

  @override
  void initState() {
    _loadAllImages();
    super.initState();
  }

  Future<void> _loadAllImages() async {
    setState(() {
      _loadingImage = true;
    });
    //
    final file = File(widget.imageFilePath);
    final imageData = await file.readAsBytes();
    setState(() {
      this.imageData = imageData;
    });
    //
    setState(() {
      _loadingImage = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Изменить аватар',
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.cut),
            onPressed: () {
              isProcessing = true;
              _controller.crop();
            },
          ),
        ],
        iconTheme: const IconThemeData(
          color: Colors.black87,
        ),
      ),
      body: Visibility(
        visible: !_loadingImage && !_isProcessing,
        replacement: const Center(child: CircularProgressIndicator()),
        child: imageData != null && imageData!.isNotEmpty
            ? Crop(
                controller: _controller,
                image: imageData!,
                initialSize: 0.5,
                aspectRatio: 1,
                onCropped: (cropped) {
                  isProcessing = false;
                  Navigator.of(context).pop(cropped);
                },
              )
            : const Text('Не удалось загрузить данные, попробуйте ещё раз'),
      ),
    );
  }
}
