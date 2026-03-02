import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dairymart/features/profile/presentation/providers/profile_provider.dart';
import 'package:dairymart/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:dairymart/features/profile/presentation/pages/profile_details_page.dart';
import 'package:dairymart/features/auth/presentation/pages/login_page.dart';
import 'package:dairymart/core/services/storage/user_session_service.dart';
import 'package:dairymart/core/api/api_endpoints.dart';
import 'package:dairymart/app/theme/theme_provider.dart';
import 'package:dairymart/features/chat/presentation/pages/chat_page.dart';

class AppDrawer extends ConsumerStatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const AppDrawer({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  ConsumerState<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends ConsumerState<AppDrawer> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => 
      ref.read(profileUpdateProvider.notifier).fetchProfile()
    );
  }

  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentImage = ref.watch(currentProfileImageProvider);
    final themeNotifier = ref.watch(themeProvider.notifier);
    final isAuto = themeNotifier.isAutoMode;

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 60, bottom: 20, left: 24, right: 24),
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.light ? Colors.white : colorScheme.surface,
              border: Border(bottom: BorderSide(color: theme.dividerColor)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: colorScheme.primary.withOpacity(0.2), width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor: theme.brightness == Brightness.light ? Colors.grey[100] : Colors.white10,
                    backgroundImage: _getBackgroundImage(currentImage),
                    child: currentImage == null
                      ? Icon(Icons.person, size: 35, color: theme.hintColor)
                      : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ref.watch(userNameProvider) ?? "DairyMart",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold, 
                          fontSize: 18, 
                          color: colorScheme.onSurface
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "Welcome Back!",
                        style: GoogleFonts.poppins(
                          fontSize: 13, 
                          color: theme.hintColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Theme Toggle switch
                IconButton(
                  onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
                  icon: Icon(
                    theme.brightness == Brightness.light ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                    color: theme.brightness == Brightness.light ? Colors.grey[700] : Colors.orange,
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              children: [
                _buildDrawerItem(0, "Home", Icons.home_rounded, context),
                _buildDrawerItem(1, "Products", Icons.grid_view_rounded, context),
                _buildDrawerItem(2, "Favorites", Icons.favorite_rounded, context),
                _buildDrawerItem(3, "My Orders", Icons.receipt_long_rounded, context),
                _buildDrawerItem(4, "Settings", Icons.settings_rounded, context),
                const Divider(indent: 16, endIndent: 16),
                // Auto Theme Switch
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SwitchListTile(
                    title: Text(
                      "Auto Theme",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                    secondary: Icon(
                      Icons.brightness_auto_rounded,
                      color: isAuto ? colorScheme.primary : theme.hintColor,
                    ),
                    value: isAuto,
                    onChanged: (bool value) {
                      ref.read(themeProvider.notifier).setAutoMode(value);
                      // Force a rebuild to reflect the auto mode change and show/hide the dark mode switch
                      setState(() {});
                    },
                    activeColor: colorScheme.primary,
                  ),
                ),
                
                // Manual Dark Mode Switch (Only visible if Auto is OFF)
                if (!isAuto)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SwitchListTile(
                      title: Text(
                        "Dark Mode",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                      secondary: Icon(
                        theme.brightness == Brightness.light ? Icons.dark_mode_outlined : Icons.dark_mode,
                        color: theme.brightness == Brightness.light ? theme.hintColor : colorScheme.primary,
                      ),
                      value: theme.brightness == Brightness.dark,
                      onChanged: (bool value) {
                        ref.read(themeProvider.notifier).toggleTheme();
                        // Force a rebuild to ensure UI updates
                        setState(() {});
                      },
                      activeColor: colorScheme.primary,
                    ),
                  ),
                _buildDrawerItem(5, "Help & Support", Icons.chat_outlined, context),
                _buildDrawerItem(6, "Profile", Icons.person_outline_rounded, context),
                _buildDrawerItem(7, "Logout", Icons.logout_rounded, context),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.light ? Colors.grey[50] : colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.eco_rounded, color: colorScheme.secondary, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    "Fresh from Farm",
                    style: GoogleFonts.poppins(
                      color: theme.hintColor, 
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to logout?', style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.poppins()),
          ),
          TextButton(
            onPressed: () async {
              final sessionService = UserSessionService();
              await sessionService.clearSession();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context, 
                  MaterialPageRoute(builder: (context) => const LoginPage()), 
                  (route) => false,
                );
              }
            },
            child: Text('Logout', style: GoogleFonts.poppins(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  ImageProvider<Object>? _getBackgroundImage(dynamic image) {
    if (image is File) {
      return FileImage(image);
    } else if (image is String && image.isNotEmpty) {
      return NetworkImage(image.startsWith('http') 
        ? image 
        : 'http://${ApiEndpoints.ipAddress}:5000$image');
    }
    return null;
  }

  Widget _buildDrawerItem(int index, String title, IconData icon, BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = widget.selectedIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? colorScheme.primary.withOpacity(0.08) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? colorScheme.primary : theme.hintColor,
          size: 24,
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: isSelected ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.8),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
        onTap: () {
          if (index == 5) {
            Navigator.pop(context); 
            final userId = ref.read(userIdProvider) ?? "";
            final userName = ref.read(userNameProvider) ?? "User";
            Navigator.push(context, MaterialPageRoute(builder: (_) => ChatPage(userId: userId, userName: userName)));
          } else if (index == 6) {
            Navigator.pop(context); 
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileDetailsPage()));
          } else if (index == 7) {
            Navigator.pop(context); 
            _showLogoutDialog(context);
          } else {
            widget.onItemTapped(index);
            Navigator.pop(context); 
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        minLeadingWidth: 20,
      ),
    );
  }
}
