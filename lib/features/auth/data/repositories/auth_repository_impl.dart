import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_local_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource _authLocalDataSource;

  AuthRepositoryImpl(this._authLocalDataSource);

  @override
  Future<Either<Failure, bool>> loginUser(String email, String password) async {
    try {
      final result = await _authLocalDataSource.loginUser(email, password);
      if (result) {
        return const Right(true);
      } else {
        return Left(Failure(message: "Invalid Credentials"));
      }
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> registerUser(UserEntity user) async {
    try {
      await _authLocalDataSource.registerUser(UserModel.fromEntity(user));
      return const Right(true);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}