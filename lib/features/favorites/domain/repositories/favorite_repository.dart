import 'package:dartz/dartz.dart';
import 'package:dairymart/core/error/failure.dart';
import 'package:dairymart/features/favorites/domain/entities/favorite_entity.dart';

abstract class FavoriteRepository {
  Future<Either<Failure, List<FavoriteEntity>>> getFavorites();
  Future<Either<Failure, bool>> toggleFavorite(String productId);
  Future<Either<Failure, bool>> checkFavorite(String productId);
}


