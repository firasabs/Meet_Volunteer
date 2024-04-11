import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sce_project/intro/register_page.dart';
import 'package:sce_project/interface/meet_volunteer.dart';

void main() {
  group('Register Page Validation', () {
    testWidgets('Register button does not work when fields are empty', (WidgetTester tester) async {
      await tester.pumpWidget(RegisterPage());
      await tester.pump();

      expect(find.byKey(Key('registerButton')).first, findsOneWidget);

    });

    testWidgets('Register button does not work when username field is empty', (WidgetTester tester) async {
      await tester.pumpWidget(RegisterPage());

      await tester.enterText(find.byKey(Key('passwordField')), 'password');

      expect(find.byKey(Key('registerButton')).first, findsOneWidget);
    });

    testWidgets('Register button does not work when email field is empty', (WidgetTester tester) async {
      await tester.pumpWidget(RegisterPage());

      await tester.enterText(find.byKey(Key('passwordField')), 'password');

      expect(find.byKey(Key('registerButton')).first, findsOneWidget);
    });

    testWidgets('Register button does not work password field is empty', (WidgetTester tester) async {
      await tester.pumpWidget(RegisterPage());



    });

    testWidgets('Register button is enabled when all username email and password are filled', (WidgetTester tester) async {
      await tester.pumpWidget(RegisterPage());
      await tester.enterText(find.byKey(Key('usernameField')), 'test');
      await tester.enterText(find.byKey(Key('emailField')), 'test@example.com');
      await tester.enterText(find.byKey(Key('passwordField')), 'password');

      expect(find.byKey(Key('registerButton')).first, findsOneWidget);
    });

  });



}
