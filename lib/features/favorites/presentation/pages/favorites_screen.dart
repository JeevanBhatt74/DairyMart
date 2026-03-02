import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dairymart/features/favorites/presentation/providers/favorite_provider.dart';
import 'package:dairymart/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:dairymart/features/products/presentation/pages/product_detail_screen.dart';
import 'package:dairymart/core/api/api_endpoints.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(favoritesProvider);
    final isDark = theme.brightness == Brightness.dark;
    const primaryBlue = Color(0xFF29ABE2);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          "My Favorites",
          style: GoogleFonts.poppins(
            color: colorScheme.onSurface, 
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: colorScheme.onSurface, size: 20),
          onPressed: () {
            ref.read(dashboardIndexProvider.notifier).state = 0; // Go back to Home
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(favoritesProvider.notifier).getFavorites();
        },
        color: primaryBlue,
        child: state.isLoading && state.favorites.isEmpty
            ? const Center(child: CircularProgressIndicator(color: primaryBlue))
            : state.error != null
                ? _buildErrorState(state.error!, () => ref.read(favoritesProvider.notifier).getFavorites())
                : state.favorites.isEmpty
                    ? _buildEmptyState(theme)
                    : GridView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: state.favorites.length,
                        itemBuilder: (context, index) {
                          final fav = state.favorites[index];
                          return _buildFavoriteCard(context, ref, fav, isDark, primaryBlue);
                        },
                      ),
      ),
    );
  }

  Widget _buildErrorState(String message, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 48, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text("Oops!", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center, style: GoogleFonts.poppins(color: Colors.grey)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF29ABE2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Try Again", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        height: 600,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.favorite_outline_rounded, size: 80, color: Colors.grey[300]),
            ),
            const SizedBox(height: 24),
            Text(
              "No favorites yet",
              style: GoogleFonts.poppins(
                fontSize: 22, 
                color: Colors.grey[600], 
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Text(
                "Save items you love here to find them easily later.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 15, color: Colors.grey[400]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteCard(BuildContext context, WidgetRef ref, dynamic fav, bool isDark, Color primaryBlue) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(productId: fav.productId),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
          border: isDark ? Border.all(color: Colors.white.withOpacity(0.05)) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Area
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black26 : const Color(0xFFF1F5F9),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                      child: fav.productImage.isNotEmpty
                          ? Image.network(
                              fav.productImage.startsWith('http') 
                                ? fav.productImage 
                                : 'http://${ApiEndpoints.ipAddress}:5000${fav.productImage}',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(Icons.image_not_supported_outlined, color: Colors.grey[300]),
                            )
                          : Icon(Icons.category_outlined, color: Colors.grey[300]),
                    ),
                  ),
                  // Favorite Toggle
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () {
                        ref.read(favoritesProvider.notifier).toggleFavorite(fav.productId);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.favorite_rounded, color: Color(0xFFEF4444), size: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content Area
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fav.productName,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, 
                      fontSize: 15,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        fav.productCategory,
                        style: GoogleFonts.poppins(
                          color: Colors.grey, 
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "Best Seller",
                          style: GoogleFonts.poppins(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: primaryBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Rs. ${fav.productPrice}",
                    style: GoogleFonts.poppins(
                      color: primaryBlue, 
                      fontWeight: FontWeight.w900, 
                      fontSize: 16,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



