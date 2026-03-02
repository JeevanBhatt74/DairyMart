import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dairymart/core/error/failure.dart';
import 'package:dairymart/features/favorites/domain/entities/favorite_entity.dart';
import 'package:dairymart/features/favorites/domain/repositories/favorite_repository.dart';
import 'package:dairymart/features/favorites/data/datasources/remote/favorite_remote_data_source.dart';

final favoriteRepositoryProvider = Provider<FavoriteRepository>((ref) {
  return FavoriteRepositoryImpl(
    dataSource: ref.read(favoriteRemoteDataSourceProvider),
  );
});

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteRemoteDataSource _dataSource;

  FavoriteRepositoryImpl({required FavoriteRemoteDataSource dataSource}) : _dataSource = dataSource;

  @override
  Future<Either<Failure, List<FavoriteEntity>>> getFavorites() async {
    try {
      final favorites = await _dataSource.getFavorites();
      return Right(favorites);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFavorite(String productId) async {
    try {
      final result = await _dataSource.toggleFavorite(productId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, bool>> checkFavorite(String productId) async {
    try {
      final result = await _dataSource.checkFavorite(productId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}




