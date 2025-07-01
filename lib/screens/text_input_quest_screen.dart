import 'package:flutter/material.dart';

class TextInputQuestScreen extends StatefulWidget {
  final String question;
  final String correctAnswer;
  const TextInputQuestScreen({Key? key, required this.question, required this.correctAnswer}) : super(key: key);

  @override
  State<TextInputQuestScreen> createState() => _TextInputQuestScreenState();
}

class _TextInputQuestScreenState extends State<TextInputQuestScreen> {
  final controller = TextEditingController();
  String? _result;

  void _checkAnswer() {
    if (controller.text.trim().toLowerCase() == widget.correctAnswer.trim().toLowerCase()) {
      setState(() => _result = 'Верно!');
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) Navigator.pop(context, true);
      });
    } else {
      setState(() => _result = 'Неверно, попробуйте ещё раз.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Текстовый квест')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(widget.question, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            TextField(controller: controller, decoration: const InputDecoration(labelText: 'Ваш ответ')), 
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _checkAnswer, child: const Text('Проверить')),
            if (_result != null) Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(_result!, style: const TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
} 