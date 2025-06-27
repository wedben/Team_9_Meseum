import 'package:flutter/material.dart';

class TaskScreen extends StatelessWidget {
  final String artifactName;

  TaskScreen({required this.artifactName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Задание'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Задание для $artifactName', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            Text('🔍 Подсказка: Найди артефакт и нажми кнопку ниже.'),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true); 
              },
              child: Text('Я нашёл артефакт!'),
            )
          ],
        ),
      ),
    );
  }
}