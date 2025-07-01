import 'package:flutter/material.dart';
import 'photo_quest_screen.dart';
import 'text_input_quest_screen.dart';
import 'qr_quest_screen.dart';

class TaskScreen extends StatelessWidget {
  final String artifactName;
  final String artifactDescription;
  final String description;
  
  const TaskScreen({
    Key? key,
    required this.artifactName,
    required this.artifactDescription,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Квесты музея природы')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => PhotoQuestScreen(
                  targetLabel: 'moose',
                  description: 'Сфотографируйте или выберите фото лося.',
                  hint: 'Ищите экспонат с лосем!',
                ),
              )),
              child: Card(child: Center(child: Text('Фото-квест: Лось'))),
            ),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => PhotoQuestScreen(
                  targetLabel: 'wolf',
                  description: 'Сфотографируйте или выберите фото волка.',
                  hint: 'Ищите экспонат с волком!',
                ),
              )),
              child: Card(child: Center(child: Text('Фото-квест: Волк'))),
            ),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => TextInputQuestScreen(
                  question: 'Введите латинское название бабочки махаон',
                  correctAnswer: 'Papilio machaon',
                ),
              )),
              child: Card(child: Center(child: Text('Текст: Papilio machaon'))),
            ),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => TextInputQuestScreen(
                  question: 'Сколько лап у жука?',
                  correctAnswer: '4',
                ),
              )),
              child: Card(child: Center(child: Text('Текст: 4'))),
            ),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => QrQuestScreen(description: 'Описание для QR-квеста'),
              )),
              child: Card(child: Center(child: Text('QR-квест'))),
            ),
          ],
        ),
      ),
    );
  }
}