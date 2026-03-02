import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dairymart/features/profile/presentation/providers/profile_provider.dart';
import 'package:dairymart/features/profile/presentation/providers/loyalty_provider.dart';
import 'package:dairymart/features/profile/presentation/pages/edit_profile_page.dart';
import 'dart:io';

class ProfileDetailsPage extends ConsumerWidget {
  const ProfileDetailsPage({super.key});

  ImageProvider<Object>? _getBackgroundImage(dynamic image) {
    if (image is File) {
      return FileImage(image);
    } else if (image is String && image.isNotEmpty) {
      return NetworkImage(image.startsWith('http') 
        ? image 
        : 'http://172.31.202.131:5000$image');
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    final currentName = ref.watch(userNameProvider) ?? "Loading...";
    final currentEmail = ref.watch(userEmailProvider) ?? "Loading...";
    final currentImage = ref.watch(currentProfileImageProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: isDark ? Colors.white : Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "My Profile",
          style: GoogleFonts.poppins(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_note_rounded, color: colorScheme.primary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfilePage()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // Profile Header
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      backgroundImage: _getBackgroundImage(currentImage),
                      child: currentImage == null
                        ? Icon(Icons.person, size: 50, color: Colors.grey[400])
                        : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    currentName,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    currentEmail,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Loyalty Points Card
            _buildLoyaltyCard(ref, isDark),

            const SizedBox(height: 30),

            // Profile Info Details
            _buildInfoSection(context, isDark),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildLoyaltyCard(WidgetRef ref, bool isDark) {
    final loyaltyAsync = ref.watch(loyaltyProvider);
    return loyaltyAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const SizedBox.shrink(),
      data: (loyalty) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
              ? [const Color(0xFF1E293B), const Color(0xFF312E81)]
              : [const Color(0xFFEEF2FF), const Color(0xFFE0E7FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: isDark ? [] : [
            BoxShadow(
              color: const Color(0xFF818CF8).withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C3AED).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.stars_rounded, color: Color(0xFF7C3AED), size: 26),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Loyalty Points",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1E1B4B),
                      ),
                    ),
                    Text(
                      "${loyalty.qualifyingOrderCount} qualifying orders",
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: isDark ? Colors.white54 : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C3AED),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${loyalty.loyaltyPoints} pts",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (!loyalty.discountAvailable) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${loyalty.pointsToNextDiscount} pts to 20% discount",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: isDark ? Colors.white60 : Colors.grey[600],
                    ),
                  ),
                  Text(
                    "${loyalty.loyaltyPoints}/100",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white70 : const Color(0xFF7C3AED),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: loyalty.loyaltyPoints / 100,
                  backgroundColor: isDark ? Colors.white10 : Colors.white,
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF7C3AED)),
                  minHeight: 12,
                ),
              ),
            ] else
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Text("ðŸŽ‰", style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "20% Discount Ready!",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.green[700],
                            ),
                          ),
                          Text(
                            "Apply it at checkout for orders > Rs. 1,000",
                            style: GoogleFonts.poppins(fontSize: 12, color: Colors.green[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildSmallEarnChip("ðŸ›’ +20 pts per order", isDark),
                _buildSmallEarnChip("ðŸ”¥ +100 bonus / 5th", isDark),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallEarnChip(String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.white10 : Colors.white),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white70 : Colors.indigo[700],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            "Personal Information",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.grey[400] : Colors.grey[800],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildInfoTile(Icons.phone_outlined, "Phone", ref: (ref) => ref.watch(userPhoneProvider) ?? "Not Set", isDark: isDark),
              _buildDivider(isDark),
              _buildInfoTile(Icons.location_on_outlined, "Address", ref: (ref) => ref.watch(userAddressProvider) ?? "Not Set", isDark: isDark),
              _buildDivider(isDark),
              _buildInfoTile(Icons.alternate_email_rounded, "Email", ref: (ref) => ref.watch(userEmailProvider) ?? "Not Set", isDark: isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile(IconData icon, String label, {required String Function(WidgetRef) ref, required bool isDark}) {
    return Consumer(
      builder: (context, refWatch, child) {
        final value = ref(refWatch);
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.indigo, size: 20),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                  Text(
                    value,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(height: 1, thickness: 1, color: isDark ? Colors.white10 : Colors.grey[100], indent: 60, endIndent: 20);
  }
}


