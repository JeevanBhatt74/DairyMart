import 'package:dairymart/features/products/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.category,
    required super.stock,
    required super.image,
    required super.calories,
    required super.protein,
    required super.fat,
    required super.carbs,
    required super.isFeatured,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      stock: json['stock'] ?? 0,
      image: json['image'] ?? '',
      calories: (json['calories'] ?? 0).toDouble(),
      protein: (json['protein'] ?? 0).toDouble(),
      fat: (json['fat'] ?? 0).toDouble(),
      carbs: (json['carbohydrates'] ?? 0).toDouble(), // note: backend sends 'carbohydrates' or 'carbs'? Schema says 'carbohydrates'
      isFeatured: json['isFeatured'] ?? false,
    );
  }
}

