import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/user_entity.dart';
import '../entities/location_entity.dart'; // Import LocationEntity

abstract class AuthRepository {
  Future<Either<Failure, bool>> registerUser(UserEntity user);
  Future<Either<Failure, bool>> loginUser(String email, String password);
  Future<Either<Failure, List<LocationEntity>>> getAllLocations(); // Add this!
}