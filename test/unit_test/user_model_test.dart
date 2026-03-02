import 'package:flutter_test/flutter_test.dart';
import 'package:dairymart/features/auth/data/models/user_model.dart';

void main() {
  group('UserModel Tests', () {
    const testUserId = 'user123';
    const testFullName = 'John Doe';
    const testEmail = 'john@example.com';
    const testPassword = 'password123';
    const testPhone = '9841234567';
    const testAddress = 'Kathmandu, Nepal';

    test('UserModel constructor creates instance with all fields', () {
      const userModel = UserModel(
        userId: testUserId,
        fullName: testFullName,
        email: testEmail,
        password: testPassword,
        phone: testPhone,
        address: testAddress,
        role: 'user',
      );

      expect(userModel.userId, testUserId);
      expect(userModel.fullName, testFullName);
      expect(userModel.email, testEmail);
      expect(userModel.password, testPassword);
      expect(userModel.phone, testPhone);
      expect(userModel.address, testAddress);
      expect(userModel.role, 'user');
    });

    test('UserModel.toJson converts model to JSON correctly', () {
      const userModel = UserModel(
        userId: testUserId,
        fullName: testFullName,
        email: testEmail,
        password: testPassword,
        phone: testPhone,
        address: testAddress,
      );

      final json = userModel.toJson();

      expect(json['fullName'], testFullName);
      expect(json['email'], testEmail);
      expect(json['password'], testPassword);
      expect(json['phoneNumber'], testPhone);
      expect(json['address'], testAddress);
    });

    test('UserModel.fromJson creates model from JSON correctly', () {
      final json = {
        '_id': testUserId,
        'fullName': testFullName,
        'email': testEmail,
        'password': testPassword,
        'phoneNumber': testPhone,
        'address': testAddress,
      };

      final userModel = UserModel.fromJson(json);

      expect(userModel.userId, testUserId);
      expect(userModel.fullName, testFullName);
      expect(userModel.email, testEmail);
    });

    test('UserModel with profilePicture stores the image URL', () {
      const testProfilePicture = 'https://example.com/profile.jpg';

      const userModel = UserModel(
        userId: testUserId,
        fullName: testFullName,
        email: testEmail,
        password: testPassword,
        phone: testPhone,
        address: testAddress,
        profilePicture: testProfilePicture,
      );

      expect(userModel.profilePicture, testProfilePicture);
    });

    test('UserModel default role is set to user', () {
      const userModel = UserModel(
        userId: testUserId,
        fullName: testFullName,
        email: testEmail,
        password: testPassword,
        phone: testPhone,
        address: testAddress,
      );

      expect(userModel.role, 'user');
    });
  });
}
