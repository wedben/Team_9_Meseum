import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(MuseumQuestApp());
}

class MuseumQuestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Museum Quest',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
