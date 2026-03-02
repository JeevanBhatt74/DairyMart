import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SnackBarHelper {
  static const Color _primaryBlue = Color(0xFF29ABE2);
  static const Color _successGreen = Color(0xFF10B981);
  static const Color _errorRed = Color(0xFFEF4444);
  static const Color _warningOrange = Color(0xFFF59E0B);

  // ✅ Success Snackbar
  static void showSuccess(BuildContext context, String message) {
    _show(context, message, _successGreen, Icons.check_circle_rounded);
  }

  // ❌ Error Snackbar
  static void showError(BuildContext context, String message) {
    _show(context, message, _errorRed, Icons.error_outline_rounded);
  }

  // ⚠️ Warning Snackbar
  static void showWarning(BuildContext context, String message) {
    _show(context, message, _warningOrange, Icons.warning_amber_rounded);
  }

  // ℹ️ Info Snackbar
  static void showInfo(BuildContext context, String message) {
    _show(context, message, _primaryBlue, Icons.info_outline_rounded);
  }

  // 🛠️ Internal Helper for Premium Design
  static void _show(BuildContext context, String message, Color color, IconData icon) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24), // Lift it from bottom
        duration: const Duration(seconds: 4),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: color.withOpacity(0.1), width: 1),
          ),
          child: Row(
            children: [
              // Icon Box with accent background
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              // Message
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              // Close Action
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                icon: Icon(
                  Icons.close_rounded,
                  color: (isDark ? Colors.white : Colors.black).withOpacity(0.2),
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
