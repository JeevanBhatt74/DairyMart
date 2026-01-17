import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../features/auth/data/models/user_model.dart';

class HiveService {
  // Singleton Pattern (Optional, but good for services)
  static final HiveService _instance = HiveService._internal();
  factory HiveService() => _instance;
  HiveService._internal();

  static const String userBoxName = 'userBox';

  Future<void> init() async {
    // Initialize Hive
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);

    // Register Adapters
    Hive.registerAdapter(UserModelAdapter());
  }

  // 1. Save User
  Future<void> addUser(UserModel user) async {
    var box = await Hive.openBox<UserModel>(userBoxName);
    await box.put('currentUser', user);
  }

  // 2. Get User
  Future<UserModel?> getUser() async {
    var box = await Hive.openBox<UserModel>(userBoxName);
    return box.get('currentUser');
  }

  // 3. Delete User (Logout)
  Future<void> deleteUser() async {
    var box = await Hive.openBox<UserModel>(userBoxName);
    await box.clear();
  }
}