// Register UI implementation

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
  final primaryBlue = const Color(0xFF29ABE2);

// Commit 2: Added all register input fields (Name, Email, Phone, Pass).
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Create Account", style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 8),
            Text("Join the DairyMart family today", style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 40),

            _buildInput("Full Name", Icons.person_outline_rounded, primaryBlue),
            const SizedBox(height: 20),
            _buildInput("Email", Icons.email_outlined, primaryBlue),
            const SizedBox(height: 20),
            _buildInput("Phone Number", Icons.phone_iphone_rounded, primaryBlue),
            const SizedBox(height: 20),
            _buildInput("Password", Icons.lock_outline_rounded, primaryBlue, isPassword: true),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 2,
                ),
                onPressed: () {
                  Navigator.pop(context); 
                },
                child: Text("SIGN UP", style: GoogleFonts.poppins(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, IconData icon, Color color, {bool isPassword = false}) {
    return TextFormField(
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.grey),
        prefixIcon: Icon(icon, color: color),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: color, width: 2)),
      ),
    );
  }
}