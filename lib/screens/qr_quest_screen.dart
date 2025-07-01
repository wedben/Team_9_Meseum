import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class QrQuestScreen extends StatefulWidget {
  final String description;
  const QrQuestScreen({Key? key, required this.description}) : super(key: key);

  @override
  State<QrQuestScreen> createState() => _QrQuestScreenState();
}

class _QrQuestScreenState extends State<QrQuestScreen> {
  final picker = ImagePicker();
  String? _result;
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source, maxWidth: 600);
    if (pickedFile == null) return;

    setState(() {
      _result = null;
      _isLoading = true;
    });

    try {
      final inputImage = InputImage.fromFilePath(pickedFile.path);
      final barcodeScanner = BarcodeScanner();
      final barcodes = await barcodeScanner.processImage(inputImage);
      barcodeScanner.close();
      if (barcodes.isNotEmpty) {
        setState(() {
          _result = 'QR-код: ' + (barcodes.first.rawValue ?? '');
          _isLoading = false;
        });
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) Navigator.pop(context, true);
      } else {
        setState(() {
          _result = 'QR-код не найден.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Ошибка при сканировании: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR-квест')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(widget.description, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            if (_result != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(_result!, style: const TextStyle(fontSize: 18)),
              ),
            if (_isLoading) const CircularProgressIndicator(),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.camera),
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Сканировать QR-код'),
            ),
            const SizedBox(height: 16),
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