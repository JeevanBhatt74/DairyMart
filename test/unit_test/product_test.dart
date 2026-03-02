import 'package:flutter_test/flutter_test.dart';

// Simple Product class for testing
class Product {
  final String id;
  final String name;
  final double price;
  final int quantity;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  double calculateTotal() => price * quantity;
  
  bool isInStock() => quantity > 0;
}

void main() {
  group('Product Tests', () {
    test('Product constructor creates instance with all fields', () {
      final product = Product(
        id: '001',
        name: 'Milk',
        price: 110.0,
        quantity: 5,
      );

      expect(product.id, '001');
      expect(product.name, 'Milk');
      expect(product.price, 110.0);
      expect(product.quantity, 5);
    });

    test('Product calculateTotal returns correct total price', () {
      final product = Product(
        id: '002',
        name: 'Butter',
        price: 580.0,
        quantity: 2,
      );

      expect(product.calculateTotal(), 1160.0);
    });

    test('Product isInStock returns true when quantity is greater than zero', () {
      final product = Product(
        id: '003',
        name: 'Cheese',
        price: 1200.0,
        quantity: 10,
      );

      expect(product.isInStock(), true);
    });

    test('Product isInStock returns false when quantity is zero', () {
      final product = Product(
        id: '004',
        name: 'Ghee',
        price: 950.0,
        quantity: 0,
      );

      expect(product.isInStock(), false);
    });

    test('Product calculateTotal works with different quantities', () {
      final product1 = Product(
        id: '005',
        name: 'Yogurt',
        price: 150.0,
        quantity: 1,
      );

      final product2 = Product(
        id: '006',
        name: 'Paneer',
        price: 850.0,
        quantity: 3,
      );

      expect(product1.calculateTotal(), 150.0);
      expect(product2.calculateTotal(), 2550.0);
    });
  });
}
