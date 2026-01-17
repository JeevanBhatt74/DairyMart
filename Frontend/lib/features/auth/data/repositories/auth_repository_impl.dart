import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../models/auth_api_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, bool>> loginUser(String email, String password) async {
    try {
      await _remoteDataSource.login(email, password);
      return const Right(true);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> registerUser(UserEntity user) async {
    try {
      final apiModel = AuthApiModel.fromEntity(user);
      await _remoteDataSource.register(apiModel);
      return const Right(true);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LocationEntity>>> getAllLocations() async {
    try {
      // TODO: Implement when location API endpoint is available
      return const Right([]);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}