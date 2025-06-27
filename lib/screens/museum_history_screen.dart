import 'package:flutter/material.dart';
import 'collection_screen.dart';

class MuseumHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('История музея')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'История музея',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Expanded(child: Container()), 
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (_) => CollectionScreen()));
              },
              child: Text('К коллекции артефактов'),
            )
          ],
        ),
      ),
    );
  }
}