import 'package:dairymart/features/orders/domain/entities/order_entity.dart';

class OrderItemModel extends OrderItemEntity {
  const OrderItemModel({
    required super.productId,
    required super.productName,
    required super.productImage,
    required super.quantity,
    required super.price,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    // Determine structure based on backend response
    // Sometimes backend returns populated product, sometimes just ID
    final product = json['product'];
    String pId = '';
    String pName = '';
    String pImage = '';
    double pPrice = (json['price'] ?? 0).toDouble();
    
    if (product is Map) {
        pId = product['_id'] ?? '';
        pName = product['name'] ?? 'Product';
        pImage = product['image'] ?? '';
        if (pPrice == 0) pPrice = (product['price'] ?? 0).toDouble();
    } else {
        pId = product.toString();
        pName = json['productName'] ?? 'Product'; // Check if name is sent directly in item
        pImage = json['productImage'] ?? '';
    }

    return OrderItemModel(
      productId: pId,
      productName: pName,
      productImage: pImage,
      quantity: json['quantity'] ?? 0,
      price: pPrice,
    );
  }
}

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required List<OrderItemModel> super.items,
    required super.totalAmount,
    required super.status,
    required super.shippingAddress,
    required super.date,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    var list = json['items'] as List;
    List<OrderItemModel> itemsList = list.map((i) => OrderItemModel.fromJson(i)).toList();

    return OrderModel(
      id: json['_id'] ?? '',
      items: itemsList,
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      status: json['status'] ?? 'Pending',
      shippingAddress: json['shippingAddress'] ?? '',
      date: json['createdAt'] ?? '',
    );
  }
}

