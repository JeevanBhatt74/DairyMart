import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  final String productId;
  final String productName;
  final double productPrice;
  final String productImage;
  final String productCategory;
  final int quantity;

  const CartItemEntity({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.productCategory,
    required this.quantity,
  });

  @override
  List<Object?> get props => [productId, productName, productPrice, productImage, productCategory, quantity];
}

class CartEntity extends Equatable {
  final String id;
  final List<CartItemEntity> items;
  final double totalPrice;

  const CartEntity({
    required this.id,
    required this.items,
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [id, items, totalPrice];
}
