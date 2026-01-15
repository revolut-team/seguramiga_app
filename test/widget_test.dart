// Basic Flutter widget test for SeguroApp

import 'package:flutter_test/flutter_test.dart';
import 'package:seguro_app/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SeguroApp());

    // Verify that the app loads without errors
    await tester.pumpAndSettle();
  });
}
