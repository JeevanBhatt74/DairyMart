import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/user_entity.dart';

// IMPORTANT: Run 'dart run build_runner build' to generate this file
part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends UserEntity {
  @HiveField(0)
  final String userId;
  @HiveField(1)
  final String fullName;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String password;
  @HiveField(4)
  final String phone;

  const UserModel({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.password,
    required this.phone,
  }) : super(userId: userId, fullName: fullName, email: email, password: password, phone: phone);

  // Convert Entity to Model
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      userId: entity.userId.isEmpty ? const Uuid().v4() : entity.userId,
      fullName: entity.fullName,
      email: entity.email,
      password: entity.password,
      phone: entity.phone,
    );
  }
}