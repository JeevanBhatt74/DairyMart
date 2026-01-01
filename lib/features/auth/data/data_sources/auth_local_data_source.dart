import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';

class AuthLocalDataSource {
  final HiveInterface hive;
  
  AuthLocalDataSource(this.hive);

  Future<void> registerUser(UserModel user) async {
    var box = await hive.openBox<UserModel>('users');
    await box.put(user.userId, user);
  }

  Future<bool> loginUser(String email, String password) async {
    var box = await hive.openBox<UserModel>('users');
    try {
      final user = box.values.firstWhere(
        (element) => element.email == email && element.password == password
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}