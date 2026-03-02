import 'package:dairymart/features/cart/domain/entities/cart_entity.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.productId,
    required super.productName,
    required super.productPrice,
    required super.productImage,
    required super.productCategory,
    required super.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final product = json['product'];
    if (product == null) {
      return CartItemModel(
        productId: json['productId'] ?? '',
        productName: 'Unknown Product',
        productPrice: 0.0,
        productImage: '',
        productCategory: 'Unknown',
        quantity: json['quantity'] ?? 0,
      );
    }
    return CartItemModel(
      productId: product['_id'] ?? '',
      productName: product['name'] ?? '',
      productPrice: (product['price'] ?? 0).toDouble(),
      productImage: product['image'] ?? '',
      productCategory: product['category'] ?? '',
      quantity: json['quantity'] ?? 0,
    );
  }
}

class CartModel extends CartEntity {
  const CartModel({
    required super.id,
    required List<CartItemModel> super.items,
    required super.totalPrice,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    var list = json['items'] as List;
    List<CartItemModel> itemsList = list.map((i) => CartItemModel.fromJson(i)).toList();
    
    // Calculate total price client-side as backend might not separate it in the same structure or just to be safe
    double total = itemsList.fold(0, (sum, item) => sum + (item.productPrice * item.quantity));

    return CartModel(
      id: json['_id'] ?? '',
      items: itemsList,
      totalPrice: total,
    );
  }
}

