import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String userId;
  final String fullName;
  final String email;
  final String password;
  final String phone;

  const UserEntity({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.password,
    required this.phone,
  });

  @override
  List<Object?> get props => [userId, fullName, email, password, phone];
}