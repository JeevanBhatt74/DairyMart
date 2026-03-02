import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final int stock;
  final String image;
  // Nutritional info
  final double calories;
  final double protein;
  final double fat;
  final double carbs;
  final bool isFeatured;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.stock,
    required this.image,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.isFeatured,
  });

  @override
  List<Object?> get props => [id, name, description, price, category, stock, image, calories, protein, fat, carbs, isFeatured];
}
