import 'package:dartz/dartz.dart';
import 'package:dairymart/core/error/failure.dart';
import 'package:dairymart/features/auth/domain/repositories/auth_repository.dart';
import 'package:dairymart/core/usecases/usecase.dart';
import 'package:equatable/equatable.dart';

class LoginUseCase implements UseCase<bool, LoginParams> {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(LoginParams params) {
    return repository.loginUser(params.email, params.password);
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

