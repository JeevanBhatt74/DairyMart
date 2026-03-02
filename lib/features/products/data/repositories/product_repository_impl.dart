import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dairymart/core/error/failure.dart';
import 'package:dairymart/features/products/domain/entities/product_entity.dart';
import 'package:dairymart/features/products/domain/repositories/product_repository.dart';
import 'package:dairymart/features/products/data/datasources/remote/product_remote_data_source.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(
    dataSource: ref.read(productRemoteDataSourceProvider),
  );
});

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _dataSource;

  ProductRepositoryImpl({required ProductRemoteDataSource dataSource}) : _dataSource = dataSource;

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    try {
      final products = await _dataSource.getProducts();
      return Right(products);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductById(String id) async {
    try {
      final product = await _dataSource.getProductById(id);
      return Right(product);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createProduct(Map<String, dynamic> productData, File imageFile) async {
    try {
      await _dataSource.createProduct(productData, imageFile);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}




