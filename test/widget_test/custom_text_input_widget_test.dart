import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Custom Text Input Widget for testing
class CustomTextInput extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isPassword;
  final TextEditingController? controller;

  const CustomTextInput({
    super.key,
    required this.label,
    required this.icon,
    this.isPassword = false,
    this.controller,
  });

  @override
  State<CustomTextInput> createState() => _CustomTextInputState();
}

class _CustomTextInputState extends State<CustomTextInput> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: Icon(widget.icon),
        suffixIcon: widget.isPassword
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

void main() {
  group('CustomTextInput Widget Tests', () {
    testWidgets('CustomTextInput displays label and icon',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomTextInput(
              label: 'Email',
              icon: Icons.email,
            ),
          ),
        ),
      );

      expect(find.text('Email'), findsOneWidget);
      expect(find.byIcon(Icons.email), findsOneWidget);
    });

    testWidgets('CustomTextInput accepts user input',
        (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextInput(
              label: 'Username',
              icon: Icons.person,
              controller: controller,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'testuser');
      expect(controller.text, 'testuser');
    });

    testWidgets('CustomTextInput password field is obscured by default',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomTextInput(
              label: 'Password',
              icon: Icons.lock,
              isPassword: true,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'secret123');
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('CustomTextInput password visibility toggle works',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomTextInput(
              label: 'Password',
              icon: Icons.lock,
              isPassword: true,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'testpass');
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });
  });
}
