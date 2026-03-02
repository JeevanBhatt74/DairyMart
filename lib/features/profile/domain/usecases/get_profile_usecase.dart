import 'package:dartz/dartz.dart';
import 'package:dairymart/core/error/failure.dart';
import 'package:dairymart/core/usecases/usecase.dart';
import 'package:dairymart/features/auth/domain/entities/user_entity.dart';
import 'package:dairymart/features/profile/domain/repositories/profile_repository.dart';

class GetProfileUseCase implements UseCase<UserEntity, NoParams> {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) {
    return repository.getProfile();
  }
}



