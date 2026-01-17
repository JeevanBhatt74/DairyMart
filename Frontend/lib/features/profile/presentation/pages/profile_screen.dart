import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

// Import your dependencies
import '../../../../core/providers/shared_preferences_provider.dart';
import '../../../../core/services/storage/user_session_service.dart';
import '../../../auth/presentation/pages/login_page.dart';
import 'edit_profile_page.dart'; // <--- IMPORT THE EDIT PROFILE PAGE

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const primaryBlue = Color(0xFF29ABE2);
    const bgGrey = Color(0xFFF5F7FA);

    return Scaffold(
      backgroundColor: bgGrey,
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
                  top: 60,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage('assets/images/logo.png'), // Placeholder
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
                      color: Colors.white,
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
                        _buildStatItem('12', 'Orders', Icons.shopping_bag_outlined),
                        Container(width: 1, height: 40, color: Colors.grey[200]),
                        _buildStatItem('5', 'Pending', Icons.local_shipping_outlined),
                        Container(width: 1, height: 40, color: Colors.grey[200]),
                        _buildStatItem('\$450', 'Wallet', Icons.account_balance_wallet_outlined),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 70), // Space for the floating card

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
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                  
                  // Shopping Related Menu
                  _buildMenuCard([
                    _buildMenuItem(Icons.location_on_outlined, "Shipping Address", Colors.blue, () {}),
                    _buildDivider(),
                    _buildMenuItem(Icons.credit_card_outlined, "Payment Methods", Colors.purple, () {}),
                    _buildDivider(),
                    _buildMenuItem(Icons.favorite_border, "Wishlist", Colors.pink, () {}),
                  ]),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 10),
                    child: Text(
                      "App Settings",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),

                  // General Settings
                  _buildMenuCard([
                    // --- EDIT PROFILE LINKED HERE ---
                    _buildMenuItem(
                      Icons.person_outline_rounded, 
                      "Edit Profile", 
                      Colors.indigo, // Changed color slightly to distinguish
                      () {
                          Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => const EditProfilePage())
                        );
                      }
                    ),
                    _buildDivider(),
                    _buildMenuItem(Icons.notifications_none_outlined, "Notifications", Colors.orange, () {}),
                    _buildDivider(),
                    _buildMenuItem(Icons.headset_mic_outlined, "Help & Support", Colors.teal, () {}),
                    _buildDivider(),
                    _buildMenuItem(
                      Icons.logout_rounded, 
                      "Logout", 
                      Colors.red, 
                      () => _showLogoutDialog(context, ref),
                    ),
                  ]),
                  
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

  Widget _buildMenuCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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

  Widget _buildMenuItem(IconData icon, String title, Color color, VoidCallback onTap) {
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
                    color: Colors.black87,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey[300]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, thickness: 1, color: Colors.grey[100], indent: 60);
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
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
            color: Colors.black87,
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