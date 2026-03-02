import 'package:dartz/dartz.dart';
import 'package:dairymart/core/error/failure.dart';
import 'package:dairymart/core/usecases/usecase.dart';
import 'package:dairymart/features/favorites/domain/entities/favorite_entity.dart';
import 'package:dairymart/features/favorites/domain/repositories/favorite_repository.dart';

class GetFavoritesUseCase extends UseCase<List<FavoriteEntity>, NoParams> {
  final FavoriteRepository repository;

  GetFavoritesUseCase(this.repository);

  @override
  Future<Either<Failure, List<FavoriteEntity>>> call(NoParams params) async {
    return await repository.getFavorites();
  }
}


