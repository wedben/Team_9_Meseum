import 'package:flutter/material.dart';

class TextInputQuestScreen extends StatefulWidget {
  final String question;
  final String correctAnswer;
  final String? museumId;
  const TextInputQuestScreen({Key? key, required this.question, required this.correctAnswer, this.museumId}) : super(key: key);

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
    final isNature = widget.museumId == 'nature_museum';
    return Scaffold(
      appBar: isNature ? null : AppBar(title: Text('Текстовый квест')),
      body: Stack(
        children: [
          if (isNature)
            Image.asset(
              'assets/sprite/ramk_Shapk/shapk.png',
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
          Column(
            children: [
              if (isNature)
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        Expanded(
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: Colors.black, width: 2),
                              ),
                              child: const Text(
                                'Текстовый квест',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 48),
                      ],
                    ),
                  ),
                ),
              Expanded(
                child: Padding(
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
              ),
            ],
          ),
        ],
      ),
    );
  }
} 