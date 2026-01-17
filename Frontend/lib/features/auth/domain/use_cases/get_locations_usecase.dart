import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/location_entity.dart';
import '../repositories/auth_repository.dart';

class GetLocationsUseCase {
  final AuthRepository _repository;

  GetLocationsUseCase(this._repository);

  Future<Either<Failure, List<LocationEntity>>> call() async {
    return await _repository.getAllLocations();
  }
}