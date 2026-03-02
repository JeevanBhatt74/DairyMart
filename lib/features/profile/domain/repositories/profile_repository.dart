import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dairymart/core/error/failure.dart';
import 'package:dairymart/features/auth/domain/entities/user_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, String>> uploadProfileImage(File imageFile);
  Future<Either<Failure, UserEntity>> updateProfile(Map<String, dynamic> profileData);
  Future<Either<Failure, UserEntity>> getProfile();
}


