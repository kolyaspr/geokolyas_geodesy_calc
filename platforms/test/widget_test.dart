// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:geodesy_calc/main.dart';

void main() {
  testWidgets('GeoCalc app loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const GeoApp());

    // Verify that the app starts and shows the home page
    expect(find.text('GeoCalc'), findsOneWidget);
    expect(find.text('ПЕРЕВЕСТИ В ДЕСЯТИЧНЫЕ ГРАДУСЫ'), findsOneWidget);
    expect(find.text('ПЕРЕВОД В ГГ ММ СС'), findsOneWidget);
    expect(find.text('ПРЯМАЯ ГЕОДЕЗИЧЕСКАЯ ЗАДАЧА'), findsOneWidget);
    expect(find.text('ОБРАТНАЯ ГЕОДЕЗИЧЕСКАЯ ЗАДАЧА'), findsOneWidget);
    expect(find.text('© МИИГАиК, 2026, Сириков'), findsOneWidget);
  });
}