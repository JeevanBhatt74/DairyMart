import 'package:dartz/dartz.dart';
import 'package:dairymart/core/error/failure.dart';
import 'package:dairymart/core/usecases/usecase.dart';
import 'package:dairymart/features/cart/domain/entities/cart_entity.dart';
import 'package:dairymart/features/cart/domain/repositories/cart_repository.dart';

class ClearCartUseCase extends UseCase<CartEntity, NoParams> {
  final CartRepository repository;

  ClearCartUseCase(this.repository);

  @override
  Future<Either<Failure, CartEntity>> call(NoParams params) async {
    return await repository.clearCart();
  }
}


