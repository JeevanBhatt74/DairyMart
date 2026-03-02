import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dairymart/features/auth/domain/entities/user_entity.dart';
import 'package:dairymart/features/auth/domain/usecases/login_usecase.dart';
import 'package:dairymart/features/auth/domain/usecases/signup_usecase.dart';
import 'package:dairymart/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:dairymart/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:dairymart/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:dairymart/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:dairymart/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:dairymart/features/auth/presentation/pages/login_page.dart';
import 'package:dairymart/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:dairymart/core/utils/snackbar_helper.dart';

// 1. Inject Remote Data Source
final authRepositoryProvider = Provider((ref) {
  return AuthRepositoryImpl(ref.read(authRemoteDataSourceProvider));
});

final signupUseCaseProvider = Provider((ref) => SignupUseCase(ref.read(authRepositoryProvider)));
final loginUseCaseProvider = Provider((ref) => LoginUseCase(ref.read(authRepositoryProvider)));
final forgotPasswordUseCaseProvider = Provider((ref) => ForgotPasswordUseCase(ref.read(authRepositoryProvider)));
final verifyOTPUseCaseProvider = Provider((ref) => VerifyOTPUseCase(ref.read(authRepositoryProvider)));
final resetPasswordUseCaseProvider = Provider((ref) => ResetPasswordUseCase(ref.read(authRepositoryProvider)));

final authViewModelProvider = StateNotifierProvider<AuthViewModel, bool>((ref) {
  return AuthViewModel(
    signupUseCase: ref.read(signupUseCaseProvider),
    loginUseCase: ref.read(loginUseCaseProvider),
    forgotPasswordUseCase: ref.read(forgotPasswordUseCaseProvider),
    verifyOTPUseCase: ref.read(verifyOTPUseCaseProvider),
    resetPasswordUseCase: ref.read(resetPasswordUseCaseProvider),
  );
});

class AuthViewModel extends StateNotifier<bool> {
  final SignupUseCase _signupUseCase;
  final LoginUseCase _loginUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final VerifyOTPUseCase _verifyOTPUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;

  AuthViewModel({
    required SignupUseCase signupUseCase,
    required LoginUseCase loginUseCase,
    required ForgotPasswordUseCase forgotPasswordUseCase,
    required VerifyOTPUseCase verifyOTPUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
  })  : _signupUseCase = signupUseCase,
        _loginUseCase = loginUseCase,
        _forgotPasswordUseCase = forgotPasswordUseCase,
        _verifyOTPUseCase = verifyOTPUseCase,
        _resetPasswordUseCase = resetPasswordUseCase,
        super(false);

  Future<void> registerUser(UserEntity user, BuildContext context) async {
    state = true;
    final result = await _signupUseCase(SignupParams(user: user));
    state = false;
    
    result.fold(
      (failure) => SnackBarHelper.showError(context, failure.message),
      (success) {
        SnackBarHelper.showSuccess(
          context, 
          "Account Created Successfully! Please login with your credentials."
        );
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (context.mounted) {
            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (context) => const LoginPage())
            );
          }
        });
      },
    );
  }

  Future<void> loginUser(String email, String password, BuildContext context) async {
    state = true;
    final result = await _loginUseCase(LoginParams(email: email, password: password));
    state = false;
 
    result.fold(
      (failure) => SnackBarHelper.showError(context, failure.message),
      (success) {
        SnackBarHelper.showSuccess(context, "Login Successful! Welcome back.");
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (context.mounted) {
            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (context) => const DashboardPage())
            );
          }
        });
      },
    );
  }

  // --- FORGOT PASSWORD ---
  Future<bool> forgotPassword(String email, BuildContext context) async {
    state = true;
    final result = await _forgotPasswordUseCase(email);
    state = false;

    return result.fold(
      (failure) {
        SnackBarHelper.showError(context, failure.message);
        return false;
      },
      (success) {
        SnackBarHelper.showSuccess(context, "OTP sent to your email!");
        return true;
      },
    );
  }

  // --- VERIFY OTP ---
  Future<bool> verifyOTP(String email, String otp, BuildContext context) async {
    state = true;
    final result = await _verifyOTPUseCase(VerifyOTPParams(email: email, otp: otp));
    state = false;

    return result.fold(
      (failure) {
        SnackBarHelper.showError(context, failure.message);
        return false;
      },
      (success) {
        SnackBarHelper.showSuccess(context, "OTP Verified!");
        return true;
      },
    );
  }

  // --- RESET PASSWORD ---
  Future<bool> resetPassword(String email, String otp, String newPassword, BuildContext context) async {
    state = true;
    final result = await _resetPasswordUseCase(ResetPasswordParams(email: email, otp: otp, newPassword: newPassword));
    state = false;

    return result.fold(
      (failure) {
        SnackBarHelper.showError(context, failure.message);
        return false;
      },
      (success) {
        SnackBarHelper.showSuccess(context, "Password Reset Successfully! Please Login.");
        Navigator.popUntil(context, (route) => route.isFirst); // Go back to Login
        return true;
      },
    );
  }
}





