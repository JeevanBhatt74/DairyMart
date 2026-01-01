import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/use_cases/login_usecase.dart';
import '../../domain/use_cases/signup_usecase.dart';
import '../../data/data_sources/auth_local_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../pages/login_page.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart';

// --- DEPENDENCY INJECTION ---
final authLocalDataSourceProvider = Provider((ref) => AuthLocalDataSource(Hive));
final authRepositoryProvider = Provider((ref) => AuthRepositoryImpl(ref.read(authLocalDataSourceProvider)));
final signupUseCaseProvider = Provider((ref) => SignupUseCase(ref.read(authRepositoryProvider)));
final loginUseCaseProvider = Provider((ref) => LoginUseCase(ref.read(authRepositoryProvider)));

final authViewModelProvider = StateNotifierProvider<AuthViewModel, bool>((ref) {
  return AuthViewModel(
    ref.read(signupUseCaseProvider),
    ref.read(loginUseCaseProvider),
  );
});

// --- VIEW MODEL ---
class AuthViewModel extends StateNotifier<bool> {
  final SignupUseCase _signupUseCase;
  final LoginUseCase _loginUseCase;

  AuthViewModel(this._signupUseCase, this._loginUseCase) : super(false);

  Future<void> registerUser(UserEntity user, BuildContext context) async {
    state = true; // Loading
    final result = await _signupUseCase(user);
    state = false; // Done
    
    result.fold(
      (failure) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failure.message))),
      (success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Registered Successfully! Login now.")));
        Navigator.pop(context); // Go back to login
      },
    );
  }

  Future<void> loginUser(String email, String password, BuildContext context) async {
    state = true;
    final result = await _loginUseCase(email, password);
    state = false;

    result.fold(
      (failure) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failure.message))),
      (success) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardPage()));
      },
    );
  }
}