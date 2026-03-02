import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dairymart/core/utils/snackbar_helper.dart';

class BugReportDialog extends StatelessWidget {
  const BugReportDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const BugReportDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final descriptionController = TextEditingController();

    return AlertDialog(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.bug_report_rounded, color: Colors.orange),
          ),
          const SizedBox(width: 12),
          Text(
            "Report a Bug",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What went wrong?",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: theme.hintColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: descriptionController,
            maxLines: 4,
            style: TextStyle(color: colorScheme.onSurface),
            decoration: InputDecoration(
              hintText: "Describe the issue...",
              hintStyle: GoogleFonts.poppins(color: theme.hintColor.withOpacity(0.5)),
              filled: true,
              fillColor: theme.brightness == Brightness.light ? Colors.grey[100] : Colors.white10,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Cancel",
            style: GoogleFonts.poppins(color: theme.hintColor),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // In a real app, send data to backend here
            Navigator.pop(context);
            SnackBarHelper.showSuccess(context, "Thank you! Bug report submitted.");
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text("Submit", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}

