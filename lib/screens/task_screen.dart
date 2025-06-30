import 'package:flutter/material.dart';

class TaskScreen extends StatelessWidget {
  final String artifactName;
  final String artifactDescription;
  
  const TaskScreen({
    Key? key,
    required this.artifactName,
    required this.artifactDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Задание')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              artifactName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(artifactDescription),
            const SizedBox(height: 24),
            const Text(
              '🔍 Подсказка: Найди артефакт и нажми кнопку ниже.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Я выполнил задание!'),
            ),
          ],
        ),
      ),
    );
  }
}