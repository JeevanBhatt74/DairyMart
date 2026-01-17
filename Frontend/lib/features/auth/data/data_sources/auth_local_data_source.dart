import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';

class AuthLocalDataSource {
  final HiveInterface hive;
  
  AuthLocalDataSource(this.hive);

  // 1. THIS METHOD MUST BE NAMED 'saveUser'
  Future<void> saveUser(UserModel user) async {
    var box = await hive.openBox<UserModel>('users');
    await box.clear(); // Clear old data to keep only the current user
    await box.put('currentUser', user); 
  }

  Future<bool> loginUser(String email, String password) async {
    var box = await hive.openBox<UserModel>('users');
    // For local login (offline), we just check if the stored user matches
    if (box.isNotEmpty) {
      final storedUser = box.get('currentUser');
      return storedUser != null && storedUser.email == email && storedUser.password == password;
    }
    return false;
  }
}