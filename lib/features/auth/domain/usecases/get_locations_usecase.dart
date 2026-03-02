import 'package:dartz/dartz.dart';
import 'package:dairymart/core/error/failure.dart';
import 'package:dairymart/features/auth/domain/entities/location_entity.dart';
import 'package:dairymart/features/auth/domain/repositories/auth_repository.dart';

class GetLocationsUseCase {
  final AuthRepository _repository;

  GetLocationsUseCase(this._repository);

  Future<Either<Failure, List<LocationEntity>>> call() async {
    return await _repository.getAllLocations();
  }
}

