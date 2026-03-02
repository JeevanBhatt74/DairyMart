import 'package:dartz/dartz.dart';
import 'package:dairymart/core/error/failure.dart';
import 'package:dairymart/features/cart/domain/entities/cart_entity.dart';

abstract class CartRepository {
  Future<Either<Failure, CartEntity>> getCart();
  Future<Either<Failure, CartEntity>> addToCart(String productId, int quantity);
  Future<Either<Failure, CartEntity>> removeFromCart(String productId);
  Future<Either<Failure, CartEntity>> clearCart();
}


