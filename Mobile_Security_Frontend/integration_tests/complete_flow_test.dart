import 'package:MobileSecurityApp/app_entry.dart';
import 'package:MobileSecurityApp/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Complete Flow: Registration to ResultScreen',
      (WidgetTester tester) async {
    // await tester.pumpWidget(MobileSecurityApp);

    // Navigate to RegistrationScreen
    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();

    // Enter registration details
    await tester.enterText(
        find.byType(TextFormField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'Password1!');
    await tester.enterText(find.byType(TextFormField).at(2), 'Password1!');
    await tester.tap(find.text('I agree to the terms and conditions'));
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Login
    await tester.enterText(
        find.byType(TextFormField).first, 'test@example.com');
    await tester.enterText(find.byType(TextFormField).last, 'Password1!');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Navigate to ScanConfigurationScreen
    await tester.tap(find.text('Configure Scan'));
    await tester.pumpAndSettle();

    // Select URL Scan and Start Scan
    await tester.enterText(
        find.byType(TextFormField).first, 'https://example.com');
    await tester.tap(find.text('Start Scan'));
    await tester.pumpAndSettle();

    // Verify ResultScreen
    expect(find.text('Scan Results'), findsOneWidget);
  });
}
