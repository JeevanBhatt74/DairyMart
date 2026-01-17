import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends UserEntity {
  @override
  @HiveField(0)
  final String userId;
  @override
  @HiveField(1)
  final String fullName;
  @override
  @HiveField(2)
  final String email;
  @override
  @HiveField(3)
  final String password;
  @override
  @HiveField(4)
  final String phone;
  @override
  @HiveField(5)
  final String address;
  @override
  @HiveField(6)
  final String? profilePicture;
  @override
  @HiveField(7)
  final String role;

  const UserModel({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.password,
    required this.phone,
    required this.address,
    this.profilePicture,
    this.role = 'user',
  }) : super(
          userId: userId,
          fullName: fullName,
          email: email,
          password: password,
          phone: phone,
          address: address,
          profilePicture: profilePicture,
          role: role,
        );

  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "email": email,
      "password": password,
      "phoneNumber": phone,
      "address": address,
      "profilePicture": profilePicture,
      "role": role,
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      userId: entity.userId,
      fullName: entity.fullName,
      email: entity.email,
      password: entity.password,
      phone: entity.phone,
      address: entity.address,
      profilePicture: entity.profilePicture,
      role: entity.role,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      phone: json['phoneNumber'] ?? '',
      address: json['address'] ?? '',
      profilePicture: json['profilePicture'],
      role: json['role'] ?? 'user',
    );
  }
}