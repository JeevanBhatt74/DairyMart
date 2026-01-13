import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/user_entity.dart';
import '../view_model/auth_view_model.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _onSignup() {
    if (_formKey.currentState!.validate()) {
      final user = UserEntity(
        userId: "",
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        phone: _phoneController.text.trim(),
      );
      ref.read(authViewModelProvider.notifier).registerUser(user, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authViewModelProvider);
    const primaryColor = Color(0xFF29ABE2);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Create Account", 
          style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w600)
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                Text(
                  "Let's Get Started!",
                  style: GoogleFonts.poppins(
                    fontSize: 26, 
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D2D2D),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "Create an account to get all features",
                  style: GoogleFonts.poppins(fontSize: 15, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                
                // --- INPUT FIELDS WITH BORDERS ---
                _buildOutlinedTextField(
                  controller: _nameController, 
                  label: "Full Name", 
                  icon: Icons.person_outline
                ),
                const SizedBox(height: 20),
                
                _buildOutlinedTextField(
                  controller: _emailController, 
                  label: "Email Address", 
                  icon: Icons.email_outlined
                ),
                const SizedBox(height: 20),
                
                _buildOutlinedTextField(
                  controller: _phoneController, 
                  label: "Phone Number", 
                  icon: Icons.phone_android
                ),
                const SizedBox(height: 20),
                
                _buildOutlinedTextField(
                  controller: _passwordController, 
                  label: "Password", 
                  icon: Icons.lock_outline, 
                  isPassword: true
                ),
                
                const SizedBox(height: 40),
                
                // --- SIGN UP BUTTON ---
                isLoading 
                  ? const Center(child: CircularProgressIndicator(color: primaryColor))
                  : SizedBox(
                      height: 58,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 8,
                          shadowColor: primaryColor.withOpacity(0.4),
                        ),
                        onPressed: _onSignup,
                        child: Text(
                          "SIGN UP",
                          style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                
                const SizedBox(height: 25),
                
                // --- LOGIN LINK ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ", style: GoogleFonts.poppins(color: Colors.grey[700], fontSize: 15)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        "Login",
                        style: GoogleFonts.poppins(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- REUSABLE OUTLINED TEXT FIELD ---
  Widget _buildOutlinedTextField({
    required TextEditingController controller, 
    required String label, 
    required IconData icon, 
    bool isPassword = false
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: (value) => value!.isEmpty ? "$label is required" : null,
      style: GoogleFonts.poppins(fontSize: 15, color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.grey[600]),
        prefixIcon: Icon(icon, color: Colors.grey[500], size: 22),
        filled: true,
        fillColor: Colors.grey[50], // Very subtle background
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        
        // DEFAULT BORDER (Grey)
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        
        // FOCUSED BORDER (Blue)
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF29ABE2), width: 2),
        ),
        
        // ERROR BORDER (Red)
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
      ),
    );
  }
}