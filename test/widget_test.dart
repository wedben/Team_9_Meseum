import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:team_9_museum/main.dart';

void main() {
  testWidgets('Приложение загружается и показывает экран приветствия', (WidgetTester tester) async {
    // Запускаем приложение
    await tester.pumpWidget(MuseumQuestApp());

    // Проверяем, что на экране есть ожидаемый текст или элемент
    expect(find.text('Сырная Тайна Костромы'), findsOneWidget); // Замените на актуальный текст в WelcomeScreen
  });
}
