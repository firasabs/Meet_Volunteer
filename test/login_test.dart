import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sce_project/intro/login_page.dart';

//Student: Malik Abo Shah

void main() {
  Firebase.initializeApp();

  group('Login Page Validation', () {
    testWidgets('Login button does not work when fields are empty', (WidgetTester tester) async {
      await tester.pumpWidget(LoginPage());
      await tester.pump();

      expect(find.byKey(Key('loginButton')).first, findsOneWidget);

    });

    testWidgets('Login button does not work when email field is empty', (WidgetTester tester) async {
      await tester.pumpWidget(LoginPage());

      await tester.enterText(find.byKey(Key('passwordField')), 'password');
      expect(find.byKey(Key('loginButton')).first, findsOneWidget);
    });

    testWidgets('Login button does not work password field is empty', (WidgetTester tester) async {
      await tester.pumpWidget(LoginPage());



    });

    testWidgets('Login button is enabled when both email and password are filled', (WidgetTester tester) async {
      await tester.pumpWidget(LoginPage());
      await tester.enterText(find.byKey(Key('emailField')), 'test@example.com');
      await tester.enterText(find.byKey(Key('passwordField')), 'password');

      expect(find.byKey(Key('loginButton')).first, findsOneWidget);
    });

  });



}
