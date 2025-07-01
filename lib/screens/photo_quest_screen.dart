import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

class PhotoQuestScreen extends StatefulWidget {
  final String targetLabel;
  final String description;
  final String hint;

  const PhotoQuestScreen({
    Key? key,
    required this.targetLabel,
    required this.description,
    required this.hint,
  }) : super(key: key);

  @override
  State<PhotoQuestScreen> createState() => _PhotoQuestScreenState();
}

class _PhotoQuestScreenState extends State<PhotoQuestScreen> {
  final picker = ImagePicker();
  File? _image;
  String? _result;
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source, maxWidth: 600);
    if (pickedFile == null) return;

    setState(() {
      _image = File(pickedFile.path);
      _result = null;
      _isLoading = true;
    });

    try {
      final inputImage = InputImage.fromFilePath(_image!.path);
      final imageLabeler = ImageLabeler(
        options: ImageLabelerOptions(confidenceThreshold: 0.5),
      );
      final labels = await imageLabeler.processImage(inputImage);
      imageLabeler.close();

      final found = labels.any((label) =>
        label.label.toLowerCase().contains(widget.targetLabel.toLowerCase())
      );

      setState(() {
        _result = found
            ? 'Поздравляем! На фото найден: ${widget.targetLabel}'
            : 'На фото не найден ${widget.targetLabel}. Попробуйте ещё раз.';
        _isLoading = false;
      });

      if (found) {
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        _result = 'Ошибка при распознавании: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Фото-квест: ${widget.targetLabel}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(widget.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            if (widget.targetLabel == 'wolf')
              Center(
                child: Image.asset(
                  'assets/images/sled.png',
                  height: 180,
                  fit: BoxFit.contain,
                ),
              ),
            if (widget.targetLabel != 'wolf')
              Text('Подсказка: ${widget.hint}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 16),
            if (_image != null)
              Image.file(_image!, height: 250, fit: BoxFit.contain),
            if (_result != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(_result!, style: const TextStyle(fontSize: 18)),
              ),
            if (_isLoading) const CircularProgressIndicator(),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.camera),
              icon: const Icon(Icons.camera_alt),
              label: const Text('Сделать фото'),
            ),
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.gallery),
              icon: const Icon(Icons.photo_library),
              label: const Text('Выбрать из галереи'),
            ),
          ],
        ),
      ),
    );
  }
}
