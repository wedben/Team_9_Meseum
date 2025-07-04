import 'package:flutter/material.dart';
import 'intro_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/icon.png',
                width: 120,
                height: 120,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 24),
              Text(
                'Museum Quest',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => IntroScreen()));
                },
                child: Text('Продолжить'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
