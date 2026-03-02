import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dairymart/core/error/failure.dart';
import 'package:dairymart/core/usecases/usecase.dart';
import 'package:dairymart/features/profile/domain/repositories/profile_repository.dart';

class UploadProfileImageUseCase implements UseCase<String, File> {
  final ProfileRepository repository;

  UploadProfileImageUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(File params) {
    return repository.uploadProfileImage(params);
  }
}


