import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dairymart/core/error/failure.dart';
import 'package:dairymart/features/cart/domain/entities/cart_entity.dart';
import 'package:dairymart/features/cart/domain/repositories/cart_repository.dart';
import 'package:dairymart/features/cart/data/datasources/remote/cart_remote_data_source.dart';

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepositoryImpl(
    dataSource: ref.read(cartRemoteDataSourceProvider),
  );
});

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource _dataSource;

  CartRepositoryImpl({required CartRemoteDataSource dataSource}) : _dataSource = dataSource;

  @override
  Future<Either<Failure, CartEntity>> getCart() async {
    try {
      final cart = await _dataSource.getCart();
      return Right(cart);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> addToCart(String productId, int quantity) async {
    try {
      final cart = await _dataSource.addToCart(productId, quantity);
      return Right(cart);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> removeFromCart(String productId) async {
    try {
      final cart = await _dataSource.removeFromCart(productId);
      return Right(cart);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> clearCart() async {
    try {
      final cart = await _dataSource.clearCart();
      return Right(cart);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}




