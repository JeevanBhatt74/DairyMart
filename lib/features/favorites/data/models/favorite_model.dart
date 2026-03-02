import 'package:dairymart/features/favorites/domain/entities/favorite_entity.dart';

class FavoriteModel extends FavoriteEntity {
  const FavoriteModel({
    required super.id,
    required super.productId,
    required super.productName,
    required super.productPrice,
    required super.productImage,
    required super.productCategory,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    final product = json['product'] ?? {};
    return FavoriteModel(
      id: json['_id'] ?? '',
      productId: product['_id'] ?? '',
      productName: product['name'] ?? '',
      productPrice: (product['price'] ?? 0).toDouble(),
      productImage: product['image'] ?? '',
      productCategory: product['category'] ?? '',
    );
  }
}

