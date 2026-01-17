import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/use_cases/login_usecase.dart';
import '../../domain/use_cases/signup_usecase.dart';
import '../../data/data_sources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../pages/login_page.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart';
import '../../../../core/utils/snackbar_helper.dart';

// 1. Inject Remote Data Source
final authRepositoryProvider = Provider((ref) {
  return AuthRepositoryImpl(ref.read(authRemoteDataSourceProvider));
});

final signupUseCaseProvider = Provider((ref) => SignupUseCase(ref.read(authRepositoryProvider)));
final loginUseCaseProvider = Provider((ref) => LoginUseCase(ref.read(authRepositoryProvider)));

final authViewModelProvider = StateNotifierProvider<AuthViewModel, bool>((ref) {
  return AuthViewModel(
    ref.read(signupUseCaseProvider),
    ref.read(loginUseCaseProvider),
  );
});

class AuthViewModel extends StateNotifier<bool> {
  final SignupUseCase _signupUseCase;
  final LoginUseCase _loginUseCase;

  AuthViewModel(this._signupUseCase, this._loginUseCase) : super(false);

  Future<void> registerUser(UserEntity user, BuildContext context) async {
    state = true;
    final result = await _signupUseCase(user);
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
    final result = await _loginUseCase(email, password);
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
}