import 'package:dartz/dartz.dart';
import 'package:dairymart/core/error/failure.dart';
import 'package:dairymart/core/usecases/usecase.dart';
import 'package:dairymart/features/cart/domain/entities/cart_entity.dart';
import 'package:dairymart/features/cart/domain/repositories/cart_repository.dart';

class AddToCartParams {
  final String productId;
  final int quantity;

  AddToCartParams({required this.productId, required this.quantity});
}

class AddToCartUseCase extends UseCase<CartEntity, AddToCartParams> {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  @override
  Future<Either<Failure, CartEntity>> call(AddToCartParams params) async {
    return await repository.addToCart(params.productId, params.quantity);
  }
}


