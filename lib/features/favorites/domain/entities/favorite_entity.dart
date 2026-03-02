import 'package:equatable/equatable.dart';

class FavoriteEntity extends Equatable {
  final String id;
  final String productId;
  final String productName;
  final double productPrice;
  final String productImage;
  final String productCategory;

  const FavoriteEntity({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.productCategory,
  });

  @override
  List<Object?> get props => [id, productId, productName, productPrice, productImage, productCategory];
}
