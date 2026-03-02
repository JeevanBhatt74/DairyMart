import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

// Import your dependencies
import 'package:dairymart/core/services/storage/user_session_service.dart';
import 'package:dairymart/features/auth/presentation/pages/login_page.dart';
import 'package:dairymart/features/profile/presentation/pages/profile_details_page.dart';
import 'package:dairymart/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:dairymart/features/admin/presentation/pages/admin_dashboard_screen.dart';
import 'package:dairymart/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:dairymart/features/profile/presentation/providers/profile_provider.dart';
import 'package:dairymart/features/chat/presentation/pages/chat_page.dart';
import 'package:dairymart/features/profile/presentation/providers/loyalty_provider.dart';

// Provider to get user role
final userRoleProvider = FutureProvider<String?>((ref) async {
  final sessionService = ref.read(userSessionServiceProvider);
  return await sessionService.getRole();
});

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  /// Get the appropriate image provider based on image type
  ImageProvider<Object>? _getBackgroundImage(dynamic image) {
    if (image is File) {
      return FileImage(image);
    } else if (image is String && image.isNotEmpty) {
      return NetworkImage(image);
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Watch the current profile image
    final currentImage = ref.watch(currentProfileImageProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF5F7FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- 1. MODERN HEADER SECTION ---
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // Blue Background Curve
                Container(
                  height: 260,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF29ABE2), Color(0xFF4FC3F7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),

                // User Info inside the Blue Header
                Positioned(
                  top: 40,
                  left: 20,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () {
                      ref.read(dashboardIndexProvider.notifier).state = 0; // Go to Home
                    },
                  ),
                ),
                Positioned(
                  top: 60,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: InkWell(
                          onTap: () {
                            Scaffold.of(context).openDrawer();
                          },
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            backgroundImage: _getBackgroundImage(currentImage),
                            child: currentImage == null
                              ? Icon(Icons.person, size: 50, color: Colors.grey[400])
                              : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Jeevan Bhatt',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'jeevan@dairymart.com',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),

                // --- 2. FLOATING STATS CARD ---
                Positioned(
                  bottom: -50,
                  left: 20,
                  right: 20,
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF29ABE2).withOpacity(0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem('12', 'Orders', Icons.shopping_bag_outlined, isDark),
                        Container(width: 1, height: 40, color: isDark ? Colors.white12 : Colors.grey[200]),
                        _buildStatItem('5', 'Pending', Icons.local_shipping_outlined, isDark),
                        Container(width: 1, height: 40, color: isDark ? Colors.white12 : Colors.grey[200]),
                        Builder(
                          builder: (context) {
                            final loyaltyAsync = ref.watch(loyaltyProvider);
                            final pts = loyaltyAsync.value?.loyaltyPoints ?? 0;
                            return _buildStatItem('$pts', 'Points', Icons.stars_rounded, isDark);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 70), // Space for the floating card

            const SizedBox(height: 20),

            // --- 3. MENU OPTIONS ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 10),
                    child: Text(
                      "Account Settings",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.grey[300] : Colors.grey[800],
                      ),
                    ),
                  ),
                  
                  // Shopping Related Menu
                  _buildMenuCard([
                    _buildMenuItem(Icons.location_on_outlined, "Shipping Address", Colors.blue, isDark, () {}),
                    _buildDivider(isDark),
                    _buildMenuItem(Icons.credit_card_outlined, "Payment Methods", Colors.purple, isDark, () {}),
                    _buildDivider(isDark),
                    _buildMenuItem(Icons.favorite_border, "Wishlist", Colors.pink, isDark, () {}),
                  ], isDark),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 10),
                    child: Text(
                      "App Settings",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.grey[300] : Colors.grey[800],
                      ),
                    ),
                  ),

                  // App Settings
                  _buildMenuCard([
                    // --- ADMIN DASHBOARD LINK ---
                    ref.watch(userRoleProvider).when(
                      data: (role) {
                        if (role == 'admin') {
                          return Column(
                            children: [
                              _buildMenuItem(
                                Icons.admin_panel_settings, 
                                "Admin Dashboard", 
                                Colors.red, 
                                isDark,
                                () {
                                  Navigator.push(
                                    context, 
                                    MaterialPageRoute(builder: (context) => const AdminDashboardScreen())
                                  );
                                }
                              ),
                              _buildDivider(isDark),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                    
                    // --- EDIT PROFILE ---
                    _buildMenuItem(
                      Icons.person_outline_rounded, 
                      "Profile", 
                      Colors.indigo, 
                      isDark,
                      () {
                          Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => const ProfileDetailsPage())
                        );
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.edit_note_rounded, color: Colors.indigo),
                        onPressed: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => const EditProfilePage())
                          );
                        },
                      ),
                    ),
                    _buildDivider(isDark),
                    _buildMenuItem(Icons.notifications_none_outlined, "Notifications", Colors.orange, isDark, () {}),
                    _buildDivider(isDark),
                    _buildMenuItem(Icons.headset_mic_outlined, "Chat with Support", Colors.teal, isDark, () {
                      final userId = ref.read(userIdProvider);
                      if (userId != null && userId.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatPage(userId: userId, userName: 'Support'),
                          ),
                        );
                      }
                    }),
                    _buildDivider(isDark),
                    _buildMenuItem(
                      Icons.logout_rounded, 
                      "Logout", 
                      Colors.red, 
                      isDark,
                      () => _showLogoutDialog(context, ref),
                    ),
                  ], isDark),
                  
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildMenuCard(List<Widget> children, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, Color color, bool isDark, VoidCallback onTap, {Widget? trailing}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              trailing ?? Icon(Icons.arrow_forward_ios_rounded, size: 16, color: isDark ? Colors.grey[600] : Colors.grey[300]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(height: 1, thickness: 1, color: isDark ? Colors.white10 : Colors.grey[100], indent: 60);
  }

  Widget _buildStatItem(String value, String label, IconData icon, bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: const Color(0xFF29ABE2), size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  // --- LOGOUT LOGIC ---
  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    const primaryBlue = Color(0xFF29ABE2);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Logout', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to logout from DairyMart?', style: GoogleFonts.poppins()),
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: primaryBlue),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(color: primaryBlue, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: primaryBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  onPressed: () async {
                    final sessionService = ref.read(userSessionServiceProvider);
                    
                    // Step 1: Clear token from FlutterSecureStorage
                    await sessionService.clearSession();
                    
                    // Step 2: Pop dialog
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                    
                    // Step 3: Navigate directly to LoginPage (NOT Splash)
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context, 
                        MaterialPageRoute(builder: (context) => const LoginPage()), 
                        (route) => false,
                      );
                    }
                  },
                  child: Text(
                    'Logout',
                    style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}




