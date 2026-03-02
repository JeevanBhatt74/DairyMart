import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:dairymart/core/error/failure.dart';
import 'package:dairymart/core/usecases/usecase.dart';
import 'package:dairymart/features/auth/domain/repositories/auth_repository.dart';

class VerifyOTPUseCase implements UseCase<bool, VerifyOTPParams> {
  final AuthRepository repository;

  VerifyOTPUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(VerifyOTPParams params) {
    return repository.verifyOTP(params.email, params.otp);
  }
}

class VerifyOTPParams extends Equatable {
  final String email;
  final String otp;

  const VerifyOTPParams({required this.email, required this.otp});

  @override
  List<Object?> get props => [email, otp];
}


