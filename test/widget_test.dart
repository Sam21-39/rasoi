import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App renders correctly', (WidgetTester tester) async {
    // Basic test - to be expanded with proper widget tests
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: Text('Rasoi App'))),
      ),
    );

    expect(find.text('Rasoi App'), findsOneWidget);
  });
}
