
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dairymart/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:dairymart/features/products/presentation/providers/product_provider.dart';
import 'package:dairymart/features/products/presentation/pages/product_detail_screen.dart';
import 'package:dairymart/features/cart/presentation/providers/cart_provider.dart';
import 'package:dairymart/core/api/api_endpoints.dart';
import 'package:dairymart/core/utils/snackbar_helper.dart';

class ProductsPage extends ConsumerStatefulWidget {
  const ProductsPage({super.key});

  @override
  ConsumerState<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  final _searchController = TextEditingController();
  final primaryBlue = const Color(0xFF29ABE2);
  String _selectedCategory = "All";
  
  final List<Map<String, dynamic>> _categories = [
    {"name": "All", "icon": Icons.inventory_2, "color": Colors.grey},
    {"name": "Milk", "icon": Icons.water_drop, "color": Colors.blue},
    {"name": "Cheese", "icon": Icons.circle, "color": Colors.amber},
    {"name": "Yogurt", "icon": Icons.icecream, "color": Colors.pink},
    {"name": "Butter", "icon": Icons.breakfast_dining, "color": Colors.orange},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // _showSearchDialog removed as we now have a persistent search bar

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productProvider);

    final filteredProducts = productState.products.where((p) {
      final matchesCategory = _selectedCategory == "All" || p.category.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesSearch = p.name.toLowerCase().contains(_searchController.text.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList()..sort((a, b) {
      if (a.isFeatured == true && b.isFeatured != true) return -1;
      if (a.isFeatured != true && b.isFeatured == true) return 1;
      return 0;
    });

    // Dark color for selected category to match Web (gray-900)
    const selectedColor = Color(0xFF111827);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text("Our Products", style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 20, color: theme.colorScheme.onSurface)),
        centerTitle: true,
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: theme.colorScheme.onSurface, size: 18),
            onPressed: () {
               ref.read(dashboardIndexProvider.notifier).state = 0;
            },
          ),
        ),
        // Search action removed from AppBar
      ),
      body: Column(
        children: [
          // Search Bar Container
          Container(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              controller: _searchController,
              style: GoogleFonts.poppins(),
              decoration: InputDecoration(
                hintText: "Search products...",
                hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                filled: true,
                fillColor: isDark ? const Color(0xFF0F172A) : Colors.grey[50],
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryBlue.withOpacity(0.5), width: 1),
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          
          // Category Chips Container
          Container(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            padding: const EdgeInsets.only(bottom: 16),
            child: SizedBox(
              height: 40,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = _selectedCategory == cat["name"];
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat["name"]),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? selectedColor : (isDark ? Colors.white.withOpacity(0.05) : Colors.grey[50]),
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected ? null : Border.all(color: isDark ? Colors.white12 : Colors.grey[200]!),
                        boxShadow: isSelected ? [
                          BoxShadow(
                            color: selectedColor.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ] : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            cat["icon"],
                            size: 16,
                            color: isSelected ? Colors.white : cat["color"],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            cat["name"],
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Product Grid
          Expanded(
            child: productState.isLoading
                ? Center(child: CircularProgressIndicator(color: primaryBlue))
                : filteredProducts.isEmpty
                    ? Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 60, color: Colors.grey[300]),
                          const SizedBox(height: 10),
                          Text("No products found", style: GoogleFonts.poppins(color: Colors.grey[500])),
                        ],
                      ))
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.62,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ProductDetailScreen(productId: product.id)),
                              );
                            },
                            child: _buildProductCard(product),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(dynamic product) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey[100]!),
        boxShadow: isDark ? [] : [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                  child: Container(
                    color: isDark ? Colors.black12 : Colors.grey[50],
                    width: double.infinity,
                    child: _buildProductImage(product.image, product.category),
                  ),
                ),
                if (product.isFeatured == true)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.black87 : Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isDark ? Colors.orange.withOpacity(0.3) : Colors.orange[100]!),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.whatshot, size: 12, color: Colors.orange),
                          const SizedBox(width: 4),
                          Text(
                            "POPULAR",
                            style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.orange[700]),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Favorite Badge
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black54 : Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
                      ],
                    ),
                    child: Icon(Icons.favorite_border, size: 16, color: isDark ? Colors.white54 : Colors.black45),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.category.toUpperCase(), 
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: theme.hintColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Rs. ${(product.price ?? 0) + 20}",
                          style: GoogleFonts.poppins(
                            decoration: TextDecoration.lineThrough,
                            color: theme.hintColor.withOpacity(0.5),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Rs. ${product.price}",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        ref.read(cartProvider.notifier).addToCart(product.id, 1);
                        SnackBarHelper.showSuccess(context, "${product.name} added to cart!");
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.onSurface,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.shopping_cart_outlined, size: 16, color: colorScheme.surface),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: (product.stock ?? 0) > 0 ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    (product.stock ?? 0) > 0 ? 'In Stock' : 'Out of Stock',
                    style: GoogleFonts.poppins(
                      fontSize: 10, 
                      fontWeight: FontWeight.w600, 
                      color: (product.stock ?? 0) > 0 ? Colors.green[400] : Colors.red[400]
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(String? url, String category) {
    if (url == null || url.isEmpty) {
      return _buildFallbackImage(category);
    }
    return Image.network(
      url.startsWith('http') ? url : '${ApiEndpoints.baseServerUrl}$url',
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return _buildFallbackImage(category);
      },
    );
  }

  Widget _buildFallbackImage(String category) {
     IconData icon;
     Color color;
     
     switch (category.toLowerCase()) {
      case 'milk': icon = Icons.water_drop; color = Colors.blue; break;
      case 'cheese': icon = Icons.circle; color = Colors.amber; break;
      case 'yogurt': icon = Icons.icecream; color = Colors.pink; break;
      case 'butter': icon = Icons.breakfast_dining; color = Colors.orange; break;
      default: icon = Icons.inventory_2; color = Colors.grey;
    }

    return Center(
      child: Icon(icon, size: 30, color: color.withOpacity(0.5)),
    );
  }
}


