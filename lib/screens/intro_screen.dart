import 'package:flutter/material.dart';
import 'menu_screen.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('О приложении')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Это приложение помогает интереснее и глубже изучить экспозицию музея.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => MenuScreen()));
              },
              child: Text('Начать исследование'),
            )
          ],
        ),
      ),
    );
  }
}
