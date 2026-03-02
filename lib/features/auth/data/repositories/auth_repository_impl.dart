import 'package:dartz/dartz.dart';
import 'package:dairymart/core/error/failure.dart';
import 'package:dairymart/features/auth/domain/entities/user_entity.dart';
import 'package:dairymart/features/auth/domain/entities/location_entity.dart';
import 'package:dairymart/features/auth/domain/repositories/auth_repository.dart';
import 'package:dairymart/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:dairymart/features/auth/data/models/auth_api_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, bool>> loginUser(String email, String password) async {
    try {
      await _remoteDataSource.login(email, password);
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> registerUser(UserEntity user) async {
    try {
      final apiModel = AuthApiModel.fromEntity(user);
      await _remoteDataSource.register(apiModel);
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LocationEntity>>> getAllLocations() async {
    try {
      // TODO: Implement when location API endpoint is available
      return const Right([]);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  @override
  Future<Either<Failure, bool>> forgotPassword(String email) async {
    try {
      await _remoteDataSource.forgotPassword(email);
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyOTP(String email, String otp) async {
    try {
      await _remoteDataSource.verifyOTP(email, otp);
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> resetPassword(String email, String otp, String newPassword) async {
    try {
      await _remoteDataSource.resetPassword(email, otp, newPassword);
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}


