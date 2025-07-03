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
    final isNature = museum.id == 'nature_museum';
    return Scaffold(
      appBar: isNature ? null : AppBar(title: Text(museum.name)),
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
                              child: Text(
                                museum.name,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (!isNature)
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}