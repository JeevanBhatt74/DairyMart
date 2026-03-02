import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dairymart/features/cart/presentation/providers/cart_provider.dart';
import 'package:dairymart/features/orders/presentation/providers/order_provider.dart';
import 'package:dairymart/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:dairymart/features/cart/presentation/pages/payment_webview_page.dart';
import 'package:dairymart/core/api/api_endpoints.dart';
import 'package:dairymart/core/services/biometric_service.dart';
import 'package:dairymart/core/utils/snackbar_helper.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  String _paymentMethod = "COD";
  final primaryBlue = const Color(0xFF29ABE2);
  final _biometricService = BiometricService();
  final _pinController = TextEditingController();

  // Loyalty points
  int _loyaltyPoints = 0;
  bool _discountAvailable = false;
  bool _useDiscount = false;
  int _qualifyingOrders = 0;
  int _pointsToNext = 100;
  int _ordersToBonus = 5;

  @override
  void initState() {
    super.initState();
    _fetchLoyaltyPoints();
  }

  Future<void> _fetchLoyaltyPoints() async {
    try {
      final storage = const FlutterSecureStorage();
      final token = await storage.read(key: 'token');
      if (token == null) return;

      final dio = Dio();
      final res = await dio.get(
        ApiEndpoints.loyaltyPoints,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (res.statusCode == 200 && res.data['success'] == true) {
        final data = res.data['data'];
        if (mounted) {
          setState(() {
            _loyaltyPoints = data['loyaltyPoints'] ?? 0;
            _discountAvailable = data['discountAvailable'] ?? false;
            _qualifyingOrders = data['qualifyingOrderCount'] ?? 0;
            _pointsToNext = data['pointsToNextDiscount'] ?? 100;
            _ordersToBonus = data['ordersToNextBonus'] ?? 5;
          });
        }
      }
    } catch (e) {
      debugPrint('Failed to fetch loyalty points: $e');
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  void _handlePaymentResult(bool success) {
    if (success) {
      ref.read(cartProvider.notifier).clearCart();
      showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel: "Order Success",
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, anim1, anim2) {
          return const SizedBox.shrink();
        },
        transitionBuilder: (context, anim1, anim2, child) {
          final curve = CurvedAnimation(parent: anim1, curve: Curves.easeOutBack);
          
          // Auto redirect after 2.5 seconds
          if (anim1.status == AnimationStatus.completed) {
            Future.delayed(const Duration(milliseconds: 2500), () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).popUntil((route) => route.isFirst);
                ref.read(dashboardIndexProvider.notifier).state = 3; // Orders Tab
              }
            });
          }

          return ScaleTransition(
            scale: curve,
            child: AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              contentPadding: const EdgeInsets.all(24),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Success Animation/Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF10B981),
                      size: 60,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Order Placed!",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Your payment was successful and your order has been placed.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Actions
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        // Navigate to Orders Tab
                        ref.read(dashboardIndexProvider.notifier).state = 3; 
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: Text(
                        "View My Orders",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        ref.read(dashboardIndexProvider.notifier).state = 0; // Go to Home
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(
                        "Return to Home",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      SnackBarHelper.showError(context, "Payment failed. Please try again.");
    }
  }

  Future<void> _initiatePayment(String orderId, double amount, String method) async {
    try {
      final dio = Dio();
      
      // Use localhost for Web, 10.0.2.2 for Android Emulator
      final baseUrl = kIsWeb ? "http://localhost:5000/api" : "http://${ApiEndpoints.ipAddress}:5000/api";
      
      String endpoint = "";
      final successUrl = kIsWeb ? "http://localhost:3000/payment/success" : "http://${ApiEndpoints.ipAddress}:3000/payment/success";
      final failureUrl = kIsWeb ? "http://localhost:3000/payment/failure" : "http://${ApiEndpoints.ipAddress}:3000/payment/failure";


      Map<String, dynamic> data = {
        "orderId": orderId,
        "amount": amount,
        "successUrl": successUrl,
        "failureUrl": failureUrl,
      };

      if (method == "ESEWA") {
        endpoint = "$baseUrl/payment/initiate/esewa";
      } else if (method == "KHALTI") {
        endpoint = "$baseUrl/payment/initiate/khalti";
        data["name"] = "Customer"; 
        data["email"] = "customer@example.com";
        data["phone"] = "9800000000";
        data["successUrl"] = successUrl;
        data["failureUrl"] = failureUrl;
      } else {
        return; // COD already handled in listener
      }

      final response = await dio.post(endpoint, data: data);

      if (response.statusCode == 200 && response.data['success']) {
         final responseData = response.data['data'];
         String paymentUrl = "";

         if (method == "ESEWA") {
            final esewaUrl = responseData['esewa_url'];
            final formFields = responseData;
            
            String html = """
              <html>
              <body onload="document.forms[0].submit()">
                <form action="$esewaUrl" method="POST">
                  ${formFields.entries.map((e) => '<input type="hidden" name="${e.key}" value="${e.value}">').join('\n')}
                </form>
              </body>
              </html>
            """;
            
            final uri = Uri.dataFromString(html, mimeType: 'text/html').toString();
            paymentUrl = uri;
         } else {
            paymentUrl = responseData['payment_url'];
         }

         if (mounted) {
            final result = await Navigator.push(
              context, 
              MaterialPageRoute(builder: (_) => PaymentWebViewPage(
                paymentUrl: paymentUrl, 
                successUrl: successUrl,
                failureUrl: failureUrl,
              ))
            );
            
            if (result == true) {
              _handlePaymentResult(true);
            } else if (result == false) {
              _handlePaymentResult(false);
            }
         }
      } else {
         SnackBarHelper.showError(context, "Failed to initiate payment");
      }
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, "Payment Error: $e");
      }
    }
  }

  Future<void> _showPinFallbackDialog(Map<String, dynamic> orderData) async {
    _pinController.clear();
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Enter Payment PIN",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Biometrics unavailable. Please enter your 4-digit security PIN to authorize this payment.",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: InputDecoration(
                hintText: "0000",
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              if (_pinController.text.length == 4) {
                Navigator.pop(context);
                ref.read(ordersProvider.notifier).createOrder(orderData);
              } else {
                SnackBarHelper.showWarning(context, "Please enter a valid 4-digit PIN");
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text("Verify", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _handlePlaceOrder(CartState cartState) async {
    if (_formKey.currentState!.validate()) {
      final orderData = {
        "items": cartState.cart!.items.map((item) => {
          "product": item.productId,
          "quantity": item.quantity
        }).toList(),
        "totalAmount": cartState.cart!.totalPrice,
        "shippingAddress": _addressController.text,
        "paymentMethod": _paymentMethod,
        "useDiscount": _useDiscount && _discountAvailable && cartState.cart!.totalPrice >= 1000,
      };

      if (_paymentMethod == "COD") {
        ref.read(ordersProvider.notifier).createOrder(orderData);
        return;
      }

      // Biometric Authentication for eSewa/Khalti
      final bool canBio = await _biometricService.canAuthenticate();
      if (canBio) {
        final bool authenticated = await _biometricService.authenticate();
        if (authenticated) {
          ref.read(ordersProvider.notifier).createOrder(orderData);
        } else {
          // User cancelled or failed biometric, show PIN fallback
          _showPinFallbackDialog(orderData);
        }
      } else {
        // Biometrics not available on device, show PIN fallback
        _showPinFallbackDialog(orderData);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    
    // Listen to Order State changes
    ref.listen<OrdersState>(ordersProvider, (previous, next) {
      if (next.isOrderCreated && next.lastCreatedOrder != null) {
         if (_paymentMethod == "COD") {
            _handlePaymentResult(true);
         } else {
            final orderId = next.lastCreatedOrder!.id; 
            final amount = next.lastCreatedOrder!.totalAmount;
            _initiatePayment(orderId, amount, _paymentMethod);
         }
         ref.read(ordersProvider.notifier).resetOrderCreated();
      } else if (next.error != null) {
        SnackBarHelper.showError(context, next.error!);
      }
    });

    if (cartState.cart == null || cartState.cart!.items.isEmpty) {
        return Scaffold(
            appBar: AppBar(title: const Text("Checkout")),
            body: const Center(child: Text("Cart is empty")),
        );
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "Checkout",
          style: GoogleFonts.poppins(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Order Summary", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  children: [
                    ...cartState.cart!.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Expanded(child: Text("${item.quantity}x ${item.productName}", style: GoogleFonts.poppins())),
                            Text("Rs. ${item.productPrice * item.quantity}", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )),
                    const Divider(height: 24),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Text("Total", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                            Text("Rs. ${cartState.cart!.totalPrice}", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: primaryBlue, fontSize: 18)),
                        ],
                    ),
                  ],
                ),
              ),
              
              // --- Loyalty Points Section ---
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryBlue.withOpacity(0.1), const Color(0xFF7C3AED).withOpacity(0.08)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: primaryBlue.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.stars_rounded, color: primaryBlue, size: 24),
                        const SizedBox(width: 8),
                        Text("Loyalty Points", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : Colors.black87)),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: primaryBlue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "$_loyaltyPoints pts",
                            style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Progress to next discount
                    if (!_discountAvailable) ...[
                      Text(
                        "$_pointsToNext more points to unlock 20% discount!",
                        style: GoogleFonts.poppins(fontSize: 12, color: isDark ? Colors.white70 : Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: _loyaltyPoints / 100,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(primaryBlue),
                          minHeight: 8,
                        ),
                      ),
                    ],
                    if (_discountAvailable && (cartState.cart?.totalPrice ?? 0) >= 1000) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "ðŸŽ‰ Use 100 pts for 20% off this order!",
                              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.green[700]),
                            ),
                          ),
                          Switch(
                            value: _useDiscount,
                            onChanged: (v) => setState(() => _useDiscount = v),
                            activeColor: primaryBlue,
                          ),
                        ],
                      ),
                      if (_useDiscount)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle, color: Colors.green, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                "You save Rs. ${((cartState.cart?.totalPrice ?? 0) * 0.2).round()}",
                                style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.green[700]),
                              ),
                            ],
                          ),
                        ),
                    ],
                    if (_discountAvailable && (cartState.cart?.totalPrice ?? 0) < 1000)
                      Text(
                        "âœ¨ Discount available! Add Rs. ${1000 - (cartState.cart?.totalPrice ?? 0).toInt()} more for 20% off",
                        style: GoogleFonts.poppins(fontSize: 12, color: Colors.orange[700]),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text("Shipping Address", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Enter your full delivery address",
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.all(16),
                ),
                validator: (value) => value!.isEmpty ? "Please enter address" : null,
              ),

              const SizedBox(height: 24),

              Text("Payment Method", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                    children: [
                        RadioListTile(
                            value: "COD", 
                            groupValue: _paymentMethod, 
                            onChanged: (val) => setState(() => _paymentMethod = val.toString()),
                            title: const Text("Cash on Delivery"),
                            secondary: const Icon(Icons.money),
                            activeColor: primaryBlue,
                        ),
                        RadioListTile(
                            value: "ESEWA", 
                            groupValue: _paymentMethod, 
                            onChanged: (val) => setState(() => _paymentMethod = val.toString()),
                            title: const Text("eSewa Mobile Wallet"),
                            secondary: const Icon(Icons.account_balance_wallet, color: Colors.green),
                            activeColor: Colors.green,
                        ),
                        RadioListTile(
                            value: "KHALTI", 
                            groupValue: _paymentMethod, 
                            onChanged: (val) => setState(() => _paymentMethod = val.toString()),
                            title: const Text("Khalti Digital Wallet"),
                            secondary: const Icon(Icons.payment, color: Colors.purple),
                            activeColor: Colors.purple,
                        ),
                    ],
                ),
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _handlePlaceOrder(cartState),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    "Place Order",
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




