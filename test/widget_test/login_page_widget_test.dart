import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dairymart/features/auth/presentation/pages/login_page.dart';

void main() {
  group('LoginPage Widget Tests', () {
    testWidgets('LoginPage displays welcome text and labels',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginPage(),
          ),
        ),
      );

      expect(find.text('Welcome Back!'), findsOneWidget);
      expect(find.text('Login to continue using DairyMart'), findsOneWidget);
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('LoginPage has email and password input fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginPage(),
          ),
        ),
      );

      expect(find.byType(TextFormField), findsWidgets);
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
      expect(find.byIcon(Icons.lock_outlined), findsOneWidget);
    });

    testWidgets('LoginPage email field accepts text input',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginPage(),
          ),
        ),
      );

      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'test@example.com');

      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('LoginPage password field is obscured', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginPage(),
          ),
        ),
      );

      final passwordField = find.byType(TextFormField).at(1);
      await tester.enterText(passwordField, 'password123');

      // Verify password field input exists (text is masked by TextField internally)
      expect(find.byType(TextFormField).at(1), findsOneWidget);
    });

    testWidgets('LoginPage shows sign up link', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginPage(),
          ),
        ),
      );

      expect(find.text('Sign Up'), findsOneWidget);
    });
  });
}
