import '../../domain/entities/user_entity.dart';

class AuthApiModel {
  final String userId;
  final String fullName;
  final String email;
  final String? password;
  
  // Updated fields to match Backend DTO
  final String phoneNumber; 
  final String address;

  AuthApiModel({
    required this.userId,
    required this.fullName,
    required this.email,
    this.password,
    required this.phoneNumber,
    required this.address,
  });

  // --- FROM JSON (Backend Response -> Flutter) ---
  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    return AuthApiModel(
      userId: json['_id'] ?? '', 
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '', // Changed from phone
      address: json['address'] ?? '',
    );
  }

  // --- TO JSON (Flutter -> Backend Request) ---
  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "email": email,
      "password": password,
      "phoneNumber": phoneNumber, // Must match DTO 'phoneNumber'
      "address": address,         // Must match DTO 'address'
    };
  }

  // --- Domain Conversions ---
  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      fullName: fullName,
      email: email,
      password: password ?? '',
      phone: phoneNumber, 
      address: address,
      profilePicture: null,
      role: 'user',
    );
  }

  factory AuthApiModel.fromEntity(UserEntity entity) {
    return AuthApiModel(
      userId: entity.userId,
      fullName: entity.fullName,
      email: entity.email,
      password: entity.password,
      phoneNumber: entity.phone,
      address: entity.address,
    );
  }
}