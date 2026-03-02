import 'package:flutter_test/flutter_test.dart';

// Simple Email Validator for testing
class EmailValidator {
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return password.length >= 8;
  }
}

void main() {
  group('EmailValidator Tests', () {
    test('isValidEmail returns true for valid email format', () {
      expect(EmailValidator.isValidEmail('test@example.com'), true);
      expect(EmailValidator.isValidEmail('user.name@domain.co.uk'), true);
    });

    test('isValidEmail returns false for invalid email format', () {
      expect(EmailValidator.isValidEmail('invalid.email'), false);
      expect(EmailValidator.isValidEmail('user@'), false);
      expect(EmailValidator.isValidEmail('@domain.com'), false);
    });

    test('isValidEmail returns false for empty string', () {
      expect(EmailValidator.isValidEmail(''), false);
    });

    test('isValidPassword returns true for valid password length', () {
      expect(EmailValidator.isValidPassword('password123'), true);
      expect(EmailValidator.isValidPassword('12345678'), true);
    });

    test('isValidPassword returns false for short password', () {
      expect(EmailValidator.isValidPassword('pass'), false);
      expect(EmailValidator.isValidPassword('123'), false);
    });
  });
}
