import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dairymart/features/products/presentation/providers/product_provider.dart';
import 'package:dairymart/features/cart/presentation/providers/cart_provider.dart';
import 'package:dairymart/features/favorites/presentation/providers/favorite_provider.dart';
import 'package:dairymart/core/api/api_endpoints.dart';
import 'package:dairymart/core/utils/snackbar_helper.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final productAsyncValue = ref.watch(productDetailProvider(widget.productId));
    final isFavoriteAsync = ref.watch(favoriteStatusProvider(widget.productId));

    return productAsyncValue.when(
      loading: () => Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(child: CircularProgressIndicator(color: colorScheme.primary)),
      ),
      error: (err, stack) => Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(child: Text('Error: $err')),
      ),
      data: (product) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 1. Sliver AppBar with Hero Image
              SliverAppBar(
                expandedHeight: MediaQuery.of(context).size.height * 0.45,
                pinned: true,
                elevation: 0,
                backgroundColor: theme.appBarTheme.backgroundColor,
                surfaceTintColor: Colors.transparent,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: theme.brightness == Brightness.light ? Colors.white.withOpacity(0.9) : Colors.black54,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios_new, size: 18, color: colorScheme.onSurface),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: theme.brightness == Brightness.light ? Colors.white.withOpacity(0.9) : Colors.black54,
                      child: IconButton(
                        icon: Icon(
                          isFavoriteAsync.asData?.value == true ? Icons.favorite : Icons.favorite_border,
                          color: isFavoriteAsync.asData?.value == true ? Colors.red : colorScheme.onSurface,
                          size: 20,
                        ),
                        onPressed: () {
                          ref.read(favoritesProvider.notifier).toggleFavorite(product.id);
                          ref.refresh(favoriteStatusProvider(product.id));
                        },
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'product_${product.id}',
                    child: _buildProductImage(context, product.image, product.category),
                  ),
                ),
              ),

              // 2. Content Section
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge & Category
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              product.category.toUpperCase(),
                              style: GoogleFonts.poppins(
                                color: colorScheme.primary,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                "4.5 (120+ Reviews)",
                                style: GoogleFonts.poppins(fontSize: 12, color: theme.hintColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Name & Price
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Rs. ${product.price}",
                                style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: colorScheme.primary),
                              ),
                              Text(
                                "per unit",
                                style: GoogleFonts.poppins(fontSize: 10, color: theme.hintColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Nutrition Grid
                      _buildNutritionGrid(context, product),
                      const SizedBox(height: 32),

                      // Description
                      Text(
                        "Product Description",
                        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        product.description,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: colorScheme.onSurface.withOpacity(0.7),
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 100), // Space for bottom bar
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: _buildAddToCartBar(context, product),
        );
      },
    );
  }

  Widget _buildNutritionGrid(BuildContext context, dynamic product) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Nutritional Facts (per 100g)",
          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: theme.hintColor),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNutritionItem(context, "Calories", "${product.calories.toInt()} kcal", Icons.local_fire_department, Colors.orange),
            _buildNutritionItem(context, "Protein", "${product.protein.toInt()}g", Icons.fitness_center, Colors.green),
            _buildNutritionItem(context, "Fat", "${product.fat.toInt()}g", Icons.opacity, Colors.orange),
            _buildNutritionItem(context, "Carbs", "${product.carbs.toInt()}g", Icons.grain, Colors.purple),
          ],
        ),
      ],
    );
  }

  Widget _buildAddToCartBar(BuildContext context, dynamic product) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.of(context).padding.bottom + 20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: theme.brightness == Brightness.light ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ] : [],
        border: theme.brightness == Brightness.dark ? Border(top: BorderSide(color: theme.dividerColor)) : null,
      ),
      child: Row(
        children: [
          // Quantity Selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.light ? Colors.grey[100] : Colors.white10,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                _buildQuantityBtn(context, Icons.remove, () {
                  if (quantity > 1) setState(() => quantity--);
                }),
                const SizedBox(width: 15),
                Text(
                  "$quantity",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: colorScheme.onSurface),
                ),
                const SizedBox(width: 15),
                _buildQuantityBtn(context, Icons.add, () => setState(() => quantity++)),
              ],
            ),
          ),
          const SizedBox(width: 20),

          // Add to Cart Button
          Expanded(
            child: SizedBox(
              height: 55,
              child: ElevatedButton(
                onPressed: product.stock > 0
                    ? () {
                        ref.read(cartProvider.notifier).addToCart(product.id, quantity);
                        SnackBarHelper.showSuccess(context, "Added $quantity ${product.name} to cart");
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.onSurface,
                  disabledBackgroundColor: theme.disabledColor.withOpacity(0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  elevation: 0,
                ),
                child: Text(
                  product.stock > 0 ? "Add to Cart" : "Out of Stock",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.surface,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityBtn(BuildContext context, IconData icon, VoidCallback onTap) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.light ? Colors.white : Colors.white12,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: theme.colorScheme.onSurface),
      ),
    );
  }

  Widget _buildNutritionItem(BuildContext context, String label, String value, IconData icon, Color color) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 8),
        Text(value, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: theme.colorScheme.onSurface)),
        Text(label, style: GoogleFonts.poppins(fontSize: 10, color: theme.hintColor)),
      ],
    );
  }

  Widget _buildProductImage(BuildContext context, String? url, String category) {
    if (url == null || url.isEmpty) {
      return _buildFallbackImage(context, category);
    }
    return Image.network(
      url.startsWith('http') ? url : '${ApiEndpoints.baseServerUrl}$url',
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        return _buildFallbackImage(context, category);
      },
    );
  }

  Widget _buildFallbackImage(BuildContext context, String category) {
    final theme = Theme.of(context);
    return Container(
      color: theme.brightness == Brightness.light ? _getCategoryColor(category) : Colors.black12,
      child: Center(
        child: Icon(_getCategoryIcon(category), size: 100, color: _getCategoryIconColor(category).withOpacity(0.5)),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'milk': return Colors.blue.shade50;
      case 'cheese': return Colors.amber.shade50;
      case 'curd':
      case 'yogurt': return Colors.pink.shade50;
      case 'cream': return Colors.purple.shade50;
      case 'ghee':
      case 'butter': return Colors.orange.shade50;
      default: return Colors.grey.shade50;
    }
  }

  Color _getCategoryIconColor(String category) {
    switch (category.toLowerCase()) {
      case 'milk': return Colors.blue.shade200;
      case 'cheese': return Colors.amber.shade300;
      case 'curd':
      case 'yogurt': return Colors.pink.shade200;
      case 'cream': return Colors.purple.shade200;
      case 'ghee':
      case 'butter': return Colors.orange.shade300;
      default: return Colors.grey.shade300;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'milk': return Icons.water_drop;
      case 'cheese': return Icons.circle; 
      case 'curd':
      case 'yogurt': return Icons.icecream;
      case 'cream': return Icons.cake;
      case 'ghee':
      case 'butter': return Icons.breakfast_dining;
      default: return Icons.inventory_2;
    }
  }
}



