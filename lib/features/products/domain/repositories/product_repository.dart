import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dairymart/core/error/failure.dart';
import 'package:dairymart/features/products/domain/entities/product_entity.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts();
  Future<Either<Failure, ProductEntity>> getProductById(String id);
  Future<Either<Failure, void>> createProduct(Map<String, dynamic> productData, File imageFile);
}


