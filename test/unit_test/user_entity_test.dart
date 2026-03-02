import 'package:flutter_test/flutter_test.dart';
import 'package:dairymart/features/auth/domain/entities/user_entity.dart';

void main() {
  group('UserEntity Tests', () {
    const testUserId = 'user_001';
    const testFullName = 'Ramesh Kumar';
    const testEmail = 'ramesh@example.com';
    const testPassword = 'securePass123';
    const testPhone = '9841234567';
    const testAddress = 'Pokhara, Nepal';

    test('UserEntity constructor creates valid instance', () {
      const userEntity = UserEntity(
        userId: testUserId,
        fullName: testFullName,
        email: testEmail,
        password: testPassword,
        phone: testPhone,
        address: testAddress,
        role: 'user',
      );

      expect(userEntity.userId, testUserId);
      expect(userEntity.fullName, testFullName);
      expect(userEntity.email, testEmail);
    });

    test('UserEntity default role is set to user', () {
      const userEntity = UserEntity(
        userId: testUserId,
        fullName: testFullName,
        email: testEmail,
        password: testPassword,
        phone: testPhone,
        address: testAddress,
      );

      expect(userEntity.role, equals('user'));
    });

    test('UserEntity with custom role creates correctly', () {
      const userEntity = UserEntity(
        userId: testUserId,
        fullName: testFullName,
        email: testEmail,
        password: testPassword,
        phone: testPhone,
        address: testAddress,
        role: 'admin',
      );

      expect(userEntity.role, 'admin');
    });

    test('UserEntity equality comparison works with Equatable', () {
      const userEntity1 = UserEntity(
        userId: testUserId,
        fullName: testFullName,
        email: testEmail,
        password: testPassword,
        phone: testPhone,
        address: testAddress,
      );

      const userEntity2 = UserEntity(
        userId: testUserId,
        fullName: testFullName,
        email: testEmail,
        password: testPassword,
        phone: testPhone,
        address: testAddress,
      );

      expect(userEntity1, equals(userEntity2));
    });

    test('UserEntity with optional profilePicture creates correctly', () {
      const profilePictureUrl = 'https://example.com/profile.jpg';
      const userEntity = UserEntity(
        userId: testUserId,
        fullName: testFullName,
        email: testEmail,
        password: testPassword,
        phone: testPhone,
        address: testAddress,
        profilePicture: profilePictureUrl,
      );

      expect(userEntity.profilePicture, profilePictureUrl);
    });
  });
}
