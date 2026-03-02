import 'package:equatable/equatable.dart';

class OrderItemEntity extends Equatable {
  final String productId;
  final String productName;
  final String productImage;
  final int quantity;
  final double price; // Price at time of order

  const OrderItemEntity({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.quantity,
    required this.price,
  });

  @override
  List<Object?> get props => [productId, productName, productImage, quantity, price];
}

class OrderEntity extends Equatable {
  final String id;
  final List<OrderItemEntity> items;
  final double totalAmount;
  final String status;
  final String shippingAddress;
  final String date;

  const OrderEntity({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.shippingAddress,
    required this.date,
  });

  @override
  List<Object?> get props => [id, items, totalAmount, status, shippingAddress, date];
}
