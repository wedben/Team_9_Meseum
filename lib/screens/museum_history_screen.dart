import 'package:flutter/material.dart';
import '../models/museum.dart';
import 'collection_screen.dart';

class MuseumHistoryScreen extends StatelessWidget {
  final Museum museum;
  
  const MuseumHistoryScreen({
    Key? key,
    required this.museum,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(museum.name)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              museum.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              museum.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              'История',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Text(museum.history),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CollectionScreen(museum: museum),
                  ),
                );
              },
              child: const Text('Начать квест'),
            ),
          ],
        ),
      ),
    );
  }
}