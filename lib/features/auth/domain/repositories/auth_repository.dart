import 'package:dartz/dartz.dart';
import 'package:dairymart/core/error/failure.dart';
import 'package:dairymart/features/auth/domain/entities/user_entity.dart';
import 'package:dairymart/features/auth/domain/entities/location_entity.dart'; // Import LocationEntity

abstract class AuthRepository {
  Future<Either<Failure, bool>> registerUser(UserEntity user);
  Future<Either<Failure, bool>> loginUser(String email, String password);
  Future<Either<Failure, List<LocationEntity>>> getAllLocations(); // Add this!
  Future<Either<Failure, bool>> forgotPassword(String email);
  Future<Either<Failure, bool>> verifyOTP(String email, String otp);
  Future<Either<Failure, bool>> resetPassword(String email, String otp, String newPassword);
}

