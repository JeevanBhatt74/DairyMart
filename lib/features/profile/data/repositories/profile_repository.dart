import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dairymart/core/error/failure.dart';
import 'package:dairymart/features/auth/data/models/user_model.dart';
import 'package:dairymart/features/auth/domain/entities/user_entity.dart';
import 'package:dairymart/features/profile/data/datasources/remote/profile_remote_data_source.dart';
import 'package:dairymart/features/profile/domain/repositories/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(ref.read(profileRemoteDataSourceProvider));
});

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, String>> uploadProfileImage(File imageFile) async {
    try {
      final imageUrl = await _remoteDataSource.uploadProfileImage(imageFile);
      return Right(imageUrl);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile(Map<String, dynamic> profileData) async {
    try {
      final result = await _remoteDataSource.updateProfile(profileData);
      return Right(UserModel.fromJson(result));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getProfile() async {
    try {
      final result = await _remoteDataSource.getProfile();
      return Right(UserModel.fromJson(result));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}






