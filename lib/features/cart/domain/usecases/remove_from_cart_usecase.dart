import 'package:dartz/dartz.dart';
import 'package:dairymart/core/error/failure.dart';
import 'package:dairymart/core/usecases/usecase.dart';
import 'package:dairymart/features/cart/domain/entities/cart_entity.dart';
import 'package:dairymart/features/cart/domain/repositories/cart_repository.dart';

class RemoveFromCartUseCase extends UseCase<CartEntity, String> {
  final CartRepository repository;

  RemoveFromCartUseCase(this.repository);

  @override
  Future<Either<Failure, CartEntity>> call(String productId) async {
    return await repository.removeFromCart(productId);
  }
}


