
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dairymart/core/services/storage/user_session_service.dart';
import 'package:dairymart/features/admin/presentation/pages/admin_dashboard_screen.dart';
import 'package:dairymart/features/auth/presentation/pages/login_page.dart';

import 'package:dairymart/features/dashboard/presentation/providers/dashboard_provider.dart';

// Provider to get user role (reused from Profile)
final userRoleProvider = FutureProvider<String?>((ref) async {
  final sessionService = ref.read(userSessionServiceProvider);
  return await sessionService.getRole();
});

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text("Settings", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
        centerTitle: true,
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: theme.colorScheme.onSurface, size: 20),
             onPressed: () {
               ref.read(dashboardIndexProvider.notifier).state = 0; // Go to Home
             },
          ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionHeader("Account", isDark),
          // Admin Dashboard (conditionally shown)
          ref.watch(userRoleProvider).when(
            data: (role) {
              if (role == 'admin') {
                return _buildSettingItem(
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
                );
              }
              return const SizedBox.shrink();
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
           _buildSettingItem(
             Icons.headset_mic_outlined, 
             "Help & Support", 
             Colors.blue, 
             isDark, 
             () => _showHelpDialog(context, isDark)
           ),
           _buildSettingItem(
             Icons.info_outline, 
             "About Us", 
             Colors.purple, 
             isDark, 
             () => _showAboutUsDialog(context, isDark)
           ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.grey[400] : Colors.grey[500],
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, Color color, bool isDark, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(isDark ? 0.1 : 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 14, color: isDark ? Colors.white : null),
        ),
        trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: isDark ? Colors.grey[600] : Colors.grey[300]),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showHelpDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        title: Text('Help & Support', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Need help with your dairy orders?', style: GoogleFonts.poppins(color: isDark ? Colors.grey[300] : Colors.grey[700])),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.email_outlined, size: 20, color: Colors.blue),
                const SizedBox(width: 8),
                Text('support@dairymart.com', style: GoogleFonts.poppins(color: isDark ? Colors.white : Colors.black)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone_outlined, size: 20, color: Colors.green),
                const SizedBox(width: 8),
                Text('+977 9800000000', style: GoogleFonts.poppins(color: isDark ? Colors.white : Colors.black)),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: GoogleFonts.poppins(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  void _showAboutUsDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        title: Text('About DairyMart', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(Icons.eco_rounded, color: Colors.green, size: 48),
            ),
            const SizedBox(height: 12),
            Text(
              'DairyMart is your trusted local platform for entirely fresh, farm-to-table dairy products. From pure milk to handcrafted cheeses, we connect local farmers directly to your kitchen.',
              style: GoogleFonts.poppins(fontSize: 14, color: isDark ? Colors.grey[300] : Colors.grey[700]),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 12),
            Text(
              'Version: 1.0.0\nMade with ❤️ in Nepal',
              style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: GoogleFonts.poppins(color: Colors.purple)),
          ),
        ],
      ),
    );
  }
}



