import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dairymart/features/orders/presentation/providers/order_provider.dart';
import 'package:dairymart/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:dairymart/core/api/api_endpoints.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(ordersProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    const primaryBlue = Color(0xFF29ABE2);

    return Scaffold(
      backgroundColor: theme.brightness == Brightness.light ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
      appBar: AppBar(
        title: Text(
          "My Orders",
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
          await ref.read(ordersProvider.notifier).getOrders();
        },
        color: primaryBlue,
        child: state.isLoading && state.orders.isEmpty
            ? const Center(child: CircularProgressIndicator(color: primaryBlue))
            : state.error != null
                ? _buildErrorState(state.error!, () => ref.read(ordersProvider.notifier).getOrders())
                : state.orders.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: state.orders.length,
                        itemBuilder: (context, index) {
                          final order = state.orders[index];
                          return _buildOrderCard(context, order, primaryBlue);
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
            Text(
              "Something went wrong",
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
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

  Widget _buildEmptyState() {
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
              child: Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey[300]),
            ),
            const SizedBox(height: 24),
            Text(
              "No orders yet",
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
                "When you place an order, it will appear here for you to track.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 15, color: Colors.grey[400]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, dynamic order, Color primaryBlue) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: theme.dividerColor.withOpacity(0.05))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ORDER #${order.id.substring(order.id.length - 8).toUpperCase()}",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w800, 
                        fontSize: 13, 
                        color: primaryBlue,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(order.date),
                      style: GoogleFonts.poppins(
                        color: Colors.grey, 
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                _buildStatusBadge(order.status),
              ],
            ),
          ),

          // Items List
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              children: order.items.map<Widget>((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        // Product Image with Frame
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: item.productImage.isNotEmpty
                                ? Image.network(
                                    item.productImage.startsWith('http') 
                                      ? item.productImage 
                                      : '${ApiEndpoints.baseServerUrl}${item.productImage}',
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Icon(Icons.image_not_supported_outlined, size: 24, color: Colors.grey[400]),
                                  )
                                : Icon(Icons.category_outlined, size: 24, color: Colors.grey[400]),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Product Name and Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.productName,
                                style: GoogleFonts.poppins(
                                  fontSize: 15, 
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    "Quantity: ",
                                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "${item.quantity}",
                                    style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: theme.colorScheme.onSurface.withOpacity(0.8)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Price
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "NPR ${item.price}",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600, 
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              "Rs. ${item.price * item.quantity}",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w800, 
                                fontSize: 15,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )).toList(),
            ),
          ),

          // Footer Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.02) : const Color(0xFFF8FAFC),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Amount",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, 
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Inclusive of all taxes",
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.grey.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                Text(
                  "Rs. ${order.totalAmount}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w900, 
                    fontSize: 22, 
                    color: primaryBlue,
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            status.toUpperCase(),
            style: GoogleFonts.poppins(
              fontSize: 11, 
              fontWeight: FontWeight.w800, 
              color: color,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String isoDate) {
    try {
      final DateTime date = DateTime.parse(isoDate);
      final List<String> months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return "${date.day} ${months[date.month - 1]}, ${date.year}";
    } catch (e) {
      return isoDate.split('T')[0];
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "pending": return const Color(0xFFF59E0B); // Amber
      case "processing": return const Color(0xFF3B82F6); // Blue
      case "shipped": return const Color(0xFF8B5CF6); // Violet
      case "delivered": return const Color(0xFF10B981); // Emerald
      case "cancelled": return const Color(0xFFEF4444); // Red
      default: return Colors.blueGrey;
    }
  }
}



