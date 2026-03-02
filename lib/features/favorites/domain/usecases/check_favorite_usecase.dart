import 'package:dartz/dartz.dart';
import 'package:dairymart/core/error/failure.dart';
import 'package:dairymart/core/usecases/usecase.dart';
import 'package:dairymart/features/favorites/domain/repositories/favorite_repository.dart';

class CheckFavoriteUseCase extends UseCase<bool, String> {
  final FavoriteRepository repository;

  CheckFavoriteUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(String productId) async {
    return await repository.checkFavorite(productId);
  }
}


