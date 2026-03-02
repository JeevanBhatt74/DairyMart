import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dairymart/features/cart/presentation/providers/cart_provider.dart';
import 'package:dairymart/features/cart/presentation/pages/checkout_page.dart';
import 'package:dairymart/core/api/api_endpoints.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Shopping Cart",
          style: GoogleFonts.poppins(color: colorScheme.onSurface, fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: colorScheme.onSurface, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        actions: [
          if (cartState.cart != null && cartState.cart!.items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                ref.read(cartProvider.notifier).clearCart();
              },
            ),
        ],
      ),
      body: cartState.isLoading
          ? Center(child: CircularProgressIndicator(color: colorScheme.primary))
          : cartState.error != null
              ? Center(child: Text("Error: ${cartState.error}", style: TextStyle(color: colorScheme.error)))
              : (cartState.cart == null || cartState.cart!.items.isEmpty)
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_cart_outlined, size: 80, color: theme.hintColor.withOpacity(0.3)),
                          const SizedBox(height: 16),
                          Text(
                            "Your cart is empty",
                            style: GoogleFonts.poppins(fontSize: 18, color: theme.hintColor),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: cartState.cart!.items.length,
                            itemBuilder: (context, index) {
                              final item = cartState.cart!.items[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: theme.cardColor,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: theme.brightness == Brightness.light ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ] : [],
                                  border: theme.brightness == Brightness.dark ? Border.all(color: Colors.white10) : null,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      // Image
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: theme.brightness == Brightness.light ? Colors.grey[100] : Colors.black26,
                                          borderRadius: BorderRadius.circular(12),
                                          image: item.productImage.isNotEmpty
                                              ? DecorationImage(
                                                  image: NetworkImage(item.productImage.startsWith('http') 
                                                    ? item.productImage 
                                                    : '${ApiEndpoints.baseServerUrl}${item.productImage}'),
                                                  fit: BoxFit.cover,
                                                )
                                              : null,
                                        ),
                                        child: item.productImage.isEmpty
                                            ? Icon(Icons.image, color: theme.hintColor)
                                            : null,
                                      ),
                                      const SizedBox(width: 16),
                                      // Details
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.productName,
                                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: colorScheme.onSurface),
                                            ),
                                            Text(
                                              item.productCategory,
                                              style: GoogleFonts.poppins(color: theme.hintColor, fontSize: 12),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "Rs. ${item.productPrice}",
                                              style: GoogleFonts.poppins(
                                                  color: colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Quantity Controls
                                      Column(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.add_circle, color: Colors.green),
                                            onPressed: () {
                                              ref.read(cartProvider.notifier).addToCart(item.productId, item.quantity + 1);
                                            },
                                          ),
                                          Text(
                                            "${item.quantity}",
                                            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.remove_circle, color: Colors.red),
                                            onPressed: () {
                                                if (item.quantity > 1) {
                                                    ref.read(cartProvider.notifier).addToCart(item.productId, item.quantity - 1);
                                                } else {
                                                    ref.read(cartProvider.notifier).removeFromCart(item.productId);
                                                }
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        // Summary
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                            boxShadow: theme.brightness == Brightness.light ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 20,
                                offset: const Offset(0, -5),
                              ),
                            ] : [],
                            border: theme.brightness == Brightness.dark ? Border(top: BorderSide(color: theme.dividerColor)) : null,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Total", style: GoogleFonts.poppins(fontSize: 16, color: theme.hintColor)),
                                  Text(
                                    "Rs. ${cartState.cart!.totalPrice.toStringAsFixed(2)}",
                                    style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const CheckoutPage()),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: colorScheme.primary,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    "Checkout",
                                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
}



