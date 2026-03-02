import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:dairymart/core/error/failure.dart';
import 'package:dairymart/core/usecases/usecase.dart';
import 'package:dairymart/features/auth/domain/repositories/auth_repository.dart';

class ForgotPasswordUseCase implements UseCase<bool, String> {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(String email) {
    return repository.forgotPassword(email);
  }
}


