import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Simple Product Card Widget for testing
class ProductCard extends StatelessWidget {
  final String productName;
  final String brandName;
  final String price;

  const ProductCard({
    super.key,
    required this.productName,
    required this.brandName,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: const Icon(Icons.image, size: 50),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  brandName,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  price,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  group('ProductCard Widget Tests', () {
    testWidgets('ProductCard displays product information',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProductCard(
              productName: 'DDC Milk',
              brandName: 'DDC Nepal',
              price: 'Rs. 110',
            ),
          ),
        ),
      );

      expect(find.text('DDC Milk'), findsOneWidget);
      expect(find.text('DDC Nepal'), findsOneWidget);
      expect(find.text('Rs. 110'), findsOneWidget);
    });

    testWidgets('ProductCard renders as a Card widget',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProductCard(
              productName: 'Butter',
              brandName: 'Amul',
              price: 'Rs. 580',
            ),
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('ProductCard displays image placeholder',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProductCard(
              productName: 'Cheese',
              brandName: 'Himalayan',
              price: 'Rs. 1200',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.image), findsOneWidget);
    });

    testWidgets('ProductCard displays multiple products in grid',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GridView.count(
              crossAxisCount: 2,
              children: const [
                ProductCard(
                  productName: 'Milk',
                  brandName: 'DDC',
                  price: 'Rs. 110',
                ),
                ProductCard(
                  productName: 'Butter',
                  brandName: 'Amul',
                  price: 'Rs. 580',
                ),
                ProductCard(
                  productName: 'Cheese',
                  brandName: 'Himalayan',
                  price: 'Rs. 1200',
                ),
                ProductCard(
                  productName: 'Ghee',
                  brandName: 'Sitaram',
                  price: 'Rs. 950',
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(ProductCard), findsWidgets);
      expect(find.text('Milk'), findsOneWidget);
      expect(find.text('Butter'), findsOneWidget);
    });

    testWidgets('ProductCard price is displayed in blue',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProductCard(
              productName: 'Yogurt',
              brandName: 'Fresh',
              price: 'Rs. 150',
            ),
          ),
        ),
      );

      final priceText = find.text('Rs. 150');
      expect(priceText, findsOneWidget);
      
      final textWidget = tester.widget<Text>(priceText);
      expect(textWidget.style?.color, Colors.blue);
    });
  });
}
