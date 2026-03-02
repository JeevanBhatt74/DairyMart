import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:dairymart/core/error/failure.dart';
import 'package:dairymart/core/usecases/usecase.dart';
import 'package:dairymart/features/auth/domain/entities/user_entity.dart';
import 'package:dairymart/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfileUseCase implements UseCase<UserEntity, UpdateProfileParams> {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(UpdateProfileParams params) {
    return repository.updateProfile(params.profileData);
  }
}

class UpdateProfileParams extends Equatable {
  final Map<String, dynamic> profileData;

  const UpdateProfileParams({required this.profileData});

  @override
  List<Object?> get props => [profileData];
}



