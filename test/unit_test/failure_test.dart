import 'package:flutter_test/flutter_test.dart';
import 'package:dairymart/core/error/failure.dart';

void main() {
  group('Failure Tests', () {
    test('ServerFailure creates instance with message', () {
      const message = 'An error occurred';
      const failure = ServerFailure(message);

      expect(failure.message, message);
    });

    test('ServerFailure message property returns correct value', () {
      const errorMessage = 'Authentication failed';
      const failure = ServerFailure(errorMessage);

      expect(failure.message, equals(errorMessage));
    });

    test('ServerFailure handles empty string message', () {
      const failure = ServerFailure('');

      expect(failure.message, isEmpty);
    });

    test('ServerFailure message can contain special characters', () {
      const message = 'Error: Network timeout (500)!';
      const failure = ServerFailure(message);

      expect(failure.message, message);
      expect(failure.message.contains('Error'), true);
    });

    test('Multiple ServerFailure instances have independent messages', () {
      const failure1 = ServerFailure('Error A');
      const failure2 = ServerFailure('Error B');

      expect(failure1.message, 'Error A');
      expect(failure2.message, 'Error B');
      expect(failure1.message != failure2.message, true);
    });
  });
}
