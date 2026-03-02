
import 'package:dairymart/features/products/presentation/pages/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dairymart/features/products/presentation/providers/product_provider.dart';
import 'package:dairymart/features/dashboard/presentation/providers/dashboard_provider.dart';

import 'package:dairymart/features/cart/presentation/providers/cart_provider.dart';
import 'package:dairymart/features/cart/presentation/pages/cart_screen.dart';
import 'package:dairymart/app/theme/theme_provider.dart';
import 'package:dairymart/features/notifications/presentation/providers/notification_provider.dart';
import 'package:dairymart/features/notifications/presentation/pages/notification_screen.dart';
import 'package:dairymart/features/dashboard/presentation/widgets/app_drawer.dart';
import 'package:dairymart/core/api/api_endpoints.dart';
import 'package:dairymart/core/utils/snackbar_helper.dart';
import 'package:dairymart/features/chatbot/presentation/pages/chatbot_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(notificationProvider.notifier).init());
  }

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final productState = ref.watch(productProvider);
    final cartState = ref.watch(cartProvider);
    final themeMode = ref.watch(themeProvider);
    
    final cartItemCount = cartState.cart?.items.length ?? 0;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: AppDrawer(
        selectedIndex: 0,
        onItemTapped: (index) {
          ref.read(dashboardIndexProvider.notifier).state = index;
        },
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.appBarTheme.backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.menu_rounded, color: colorScheme.onSurface, size: 28),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Image.asset(
          'assets/images/logo.png',
          height: 25,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Text(
              "DairyMart",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: colorScheme.primary,
              ),
            );
          },
        ),
        centerTitle: false,
        actions: [
          const SizedBox(width: 8),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: Icon(Icons.notifications_none_outlined, color: colorScheme.onSurface),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationScreen()));
                },
              ),
              Consumer(builder: (context, ref, child) {
                final unreadCount = ref.watch(unreadNotificationCountProvider);
                if (unreadCount <= 0) return const SizedBox.shrink();
                return Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Center(
                      child: Text(
                        '$unreadCount', 
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart_outlined, color: colorScheme.onSurface),
                onPressed: () {
                   Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
                },
              ),
              if (cartItemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Center(
                      child: Text(
                        '$cartItemCount', 
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF29ABE2), Color(0xFF7C3AED)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF29ABE2).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatbotScreen()));
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.smart_toy_rounded, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: theme.brightness == Brightness.light ? Colors.white : colorScheme.surface,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: theme.brightness == Brightness.light ? Colors.green[50] : colorScheme.secondary.withOpacity(0.1), 
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(radius: 3, backgroundColor: colorScheme.secondary),
                        const SizedBox(width: 8),
                        Text(
                          "FRESH FROM THE FARM", 
                          style: GoogleFonts.poppins(
                            fontSize: 10, 
                            fontWeight: FontWeight.bold, 
                            color: theme.brightness == Brightness.light ? Colors.green[700] : colorScheme.secondary
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.poppins(height: 1.1),
                      children: [
                        TextSpan(
                          text: "Pure Goodness,\n",
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: colorScheme.onSurface),
                        ),
                        TextSpan(
                          text: "Delivered To You.",
                          style: TextStyle(
                            fontSize: 32, 
                            fontWeight: FontWeight.w900, 
                            foreground: Paint()..shader = LinearGradient(
                              colors: [colorScheme.primary, colorScheme.secondary],
                            ).createShader(const Rect.fromLTWH(0.0, 0.0, 300.0, 70.0)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              color: theme.brightness == Brightness.light ? Colors.white : colorScheme.surface,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.light ? Colors.grey[100] : Colors.black26,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(color: colorScheme.onSurface),
                  decoration: InputDecoration(
                    hintText: "Search milk, cheese...",
                    hintStyle: GoogleFonts.poppins(color: theme.brightness == Brightness.light ? Colors.grey[500] : Colors.grey[400], fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: theme.brightness == Brightness.light ? Colors.grey[500] : Colors.grey[400]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onSubmitted: (_) {
                     ref.read(dashboardIndexProvider.notifier).state = 1;
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 160,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildPromoCard(
                    context,
                    "Fresh Milk", 
                    "Get 20% off\non subscription", 
                    theme.brightness == Brightness.light ? const Color(0xFFE3F2FD) : const Color(0xFF1E293B), 
                    colorScheme.primary,
                  ),
                  const SizedBox(width: 16),
                   _buildPromoCard(
                    context,
                    "Organic", 
                    "Pure Ghee\nStarting @ Rs. 500", 
                    theme.brightness == Brightness.light ? const Color(0xFFFFF8E1) : const Color(0xFF334155), 
                    Colors.orange,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text("Categories", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildCategoryCircle(context, "Milk", Icons.water_drop, Colors.blue, const Color(0xFFE3F2FD), const Color(0xFFBBDEFB)),
                  _buildCategoryCircle(context, "Cheese", Icons.circle, Colors.amber, const Color(0xFFFFF8E1), const Color(0xFFFFECB3)),
                  _buildCategoryCircle(context, "Yogurt", Icons.icecream, Colors.pink, const Color(0xFFFCE4EC), const Color(0xFFF8BBD0)),
                  _buildCategoryCircle(context, "Butter", Icons.breakfast_dining, Colors.orange, const Color(0xFFFFF3E0), const Color(0xFFFFE0B2)),
                  _buildCategoryCircle(context, "Cream", Icons.cake, Colors.purple, const Color(0xFFF3E5F5), const Color(0xFFE1BEE7)),
                  _buildCategoryCircle(context, "Ghee", Icons.sunny, Colors.orange, const Color(0xFFFFF3E0), const Color(0xFFFFE0B2)),
                ],
              ),
            ),
            const SizedBox(height: 24),
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text("Our Best Sellers", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                   TextButton(
                     onPressed: () {
                        ref.read(dashboardIndexProvider.notifier).state = 1;
                     },
                     child: Text("View All", style: GoogleFonts.poppins(color: colorScheme.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                   )
                ],
              ),
            ),
            const SizedBox(height: 12),
             productState.isLoading
              ? Center(child: CircularProgressIndicator(color: colorScheme.primary))
              : Builder(
                  builder: (context) {
                    final sortedProducts = [...productState.products]..sort((a, b) {
                      if (a.isFeatured == true && b.isFeatured != true) return -1;
                      if (a.isFeatured != true && b.isFeatured == true) return 1;
                      return 0;
                    });
                    
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.62, 
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: sortedProducts.length > 5 ? 5 : sortedProducts.length,
                      itemBuilder: (context, index) {
                        final product = sortedProducts[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProductDetailScreen(productId: product.id)),
                            );
                          },
                          child: _buildProductCard(context, product),
                        );
                      },
                    );
                  }
                ),
             const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoCard(BuildContext context, String tag, String title, Color bgColor, Color accentColor) {
    final theme = Theme.of(context);
    return Container(
      width: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(tag, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: accentColor)),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: theme.brightness == Brightness.light ? Colors.black87 : Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCircle(BuildContext context, String name, IconData icon, Color iconColor, Color bgColor, Color borderColor) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.light ? bgColor : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: theme.brightness == Brightness.light ? borderColor : Colors.white10, width: 2),
            ),
            child: Icon(icon, color: iconColor, size: 32),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: GoogleFonts.poppins(
              fontSize: 12, 
              fontWeight: FontWeight.bold, 
              color: theme.colorScheme.onSurface.withOpacity(0.8)
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, dynamic product) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: theme.brightness == Brightness.light ? Colors.grey[100]! : Colors.white10),
        boxShadow: theme.brightness == Brightness.light ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.03), 
            blurRadius: 20, 
            offset: const Offset(0, 10)
          ),
        ] : [],
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
                    color: theme.brightness == Brightness.light ? Colors.grey[50] : Colors.black12,
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
                        color: theme.brightness == Brightness.light ? Colors.white.withOpacity(0.9) : Colors.black87,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: theme.brightness == Brightness.light ? Colors.orange[100]! : Colors.orange.withOpacity(0.3)),
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
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: colorScheme.onSurface),
                ),
                Text(
                  "1 Ltr",
                  style: GoogleFonts.poppins(fontSize: 10, color: theme.hintColor, letterSpacing: 1.2),
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
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: colorScheme.onSurface),
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
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
             value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                : null,
            color: Colors.grey[200],
            strokeWidth: 2,
          ),
        );
      },
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
      case 'cream': icon = Icons.cake; color = Colors.purple; break;
      case 'butter': icon = Icons.breakfast_dining; color = Colors.orange; break;
      case 'ghee': icon = Icons.sunny; color = Colors.orange; break;
      default: icon = Icons.inventory_2; color = Colors.grey;
    }

    return Center(
      child: Icon(icon, size: 30, color: color.withOpacity(0.5)),
    );
  }
}



