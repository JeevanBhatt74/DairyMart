import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dairymart/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:dairymart/features/auth/presentation/pages/reset_password_page.dart';

class VerifyOTPPage extends ConsumerStatefulWidget {
  final String email;
  const VerifyOTPPage({super.key, required this.email});

  @override
  ConsumerState<VerifyOTPPage> createState() => _VerifyOTPPageState();
}

class _VerifyOTPPageState extends ConsumerState<VerifyOTPPage> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  int _timerSeconds = 30;
  bool _canResend = false;
  late final Stream<int> _timerStream;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timerSeconds = 30;
    _canResend = false;
    _timerStream = Stream.periodic(const Duration(seconds: 1), (i) => 30 - i - 1).take(30);
    _timerStream.listen((timeLeft) {
      if (mounted) {
        setState(() {
          _timerSeconds = timeLeft;
        });
      }
    }, onDone: () {
      if (mounted) {
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  void _onResend() async {
    final success = await ref.read(authViewModelProvider.notifier).forgotPassword(widget.email, context);
    if (success) {
      _startTimer();
    }
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      final otp = _otpController.text.trim();
      final success = await ref.read(authViewModelProvider.notifier).verifyOTP(widget.email, otp, context);
      
      if (success && mounted) {
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => ResetPasswordPage(email: widget.email, otp: otp))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authViewModelProvider);
    const primaryColor = Color(0xFF29ABE2);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Verify OTP",
                style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF2D2D2D)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "Enter the 6-digit code sent to\n${widget.email}",
                style: GoogleFonts.poppins(fontSize: 15, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _otpController,
                  validator: (value) => (value!.isEmpty || value.length != 6) ? "Enter valid 6-digit OTP" : null,
                  style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 8),
                  textAlign: TextAlign.center,
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    counterText: "",
                    filled: true,
                    fillColor: Colors.grey[50], 
                    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF29ABE2), width: 2),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Resend Timer
              Center(
                child: _canResend 
                  ? TextButton(
                      onPressed: _onResend, 
                      child: Text(
                        "Resend Code", 
                        style: GoogleFonts.poppins(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 15)
                      )
                    )
                  : Text(
                      "Resend code in $_timerSeconds s",
                      style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 14),
                    ),
              ),

              const SizedBox(height: 20),

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
                      onPressed: _onSubmit,
                      child: Text(
                        "VERIFY",
                        style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold),
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


