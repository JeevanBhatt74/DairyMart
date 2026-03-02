import 'package:dartz/dartz.dart';
import 'package:dairymart/core/error/failure.dart';
import 'package:dairymart/features/auth/domain/entities/user_entity.dart';
import 'package:dairymart/features/auth/domain/repositories/auth_repository.dart';

import 'package:dairymart/core/usecases/usecase.dart';
import 'package:equatable/equatable.dart';

class SignupUseCase implements UseCase<bool, SignupParams> {
  final AuthRepository repository;
  SignupUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(SignupParams params) {
    return repository.registerUser(params.user);
  }
}

class SignupParams extends Equatable {
  final UserEntity user;

  const SignupParams({required this.user});

  @override
  List<Object?> get props => [user];
}

