import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provides the current index of the Dashboard's IndexedStack
final dashboardIndexProvider = StateProvider<int>((ref) => 0);
