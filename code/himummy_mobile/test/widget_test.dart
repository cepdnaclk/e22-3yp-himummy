import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:himummy_mobile/main.dart';

void main() {
  testWidgets('Login screen smoke test', (WidgetTester tester) async {
    // Build our HiMummy app and trigger a frame.
    await tester.pumpWidget(const HiMummyApp());

    // Verify that the Login screen displays 'Welcome back' text.
    expect(find.text('Welcome back'), findsOneWidget);

    // Verify that the email input field hint is visible.
    expect(find.text('maya@example.com'), findsOneWidget);

    // Verify that the Login button is present.
    expect(find.text('Log in'), findsOneWidget);
  });
}