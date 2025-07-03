import 'package:flutter/material.dart';
import 'photo_quest_screen.dart';
import 'text_input_quest_screen.dart';
import 'qr_quest_screen.dart';

class TaskScreen extends StatelessWidget {
  final String artifactName;
  final String artifactDescription;
  final String description;
  final String? museumId;
  
  const TaskScreen({
    Key? key,
    required this.artifactName,
    required this.artifactDescription,
    required this.description,
    this.museumId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isNature = museumId == 'nature_museum';
    return Scaffold(
      appBar: isNature ? null : AppBar(title: const Text('Квесты музея природы')),
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
                                'Квесты музея природы',
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
                            museumId: museumId,
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
                            museumId: museumId,
                          ),
                        )),
                        child: Card(child: Center(child: Text('Фото-квест: Волк'))),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(
                          builder: (_) => TextInputQuestScreen(
                            question: 'Введите латинское название бабочки махаон',
                            correctAnswer: 'Papilio machaon',
                            museumId: museumId,
                          ),
                        )),
                        child: Card(child: Center(child: Text('Текст: Papilio machaon'))),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(
                          builder: (_) => TextInputQuestScreen(
                            question: 'Сколько лап у жука?',
                            correctAnswer: '4',
                            museumId: museumId,
                          ),
                        )),
                        child: Card(child: Center(child: Text('Текст: 4'))),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(
                          builder: (_) => QrQuestScreen(description: 'Описание для QR-квеста', museumId: museumId),
                        )),
                        child: Card(child: Center(child: Text('QR-квест'))),
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