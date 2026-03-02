import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:dairymart/core/error/failure.dart';
import 'package:dairymart/core/usecases/usecase.dart';
import 'package:dairymart/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordUseCase implements UseCase<bool, ResetPasswordParams> {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(ResetPasswordParams params) {
    return repository.resetPassword(params.email, params.otp, params.newPassword);
  }
}

class ResetPasswordParams extends Equatable {
  final String email;
  final String otp;
  final String newPassword;

  const ResetPasswordParams({
    required this.email, 
    required this.otp, 
    required this.newPassword,
  });

  @override
  List<Object?> get props => [email, otp, newPassword];
}


