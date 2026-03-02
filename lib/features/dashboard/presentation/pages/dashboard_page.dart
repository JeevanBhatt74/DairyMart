import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Feature Imports
import 'package:dairymart/features/home/presentation/pages/home_screen.dart';
import 'package:dairymart/features/favorites/presentation/pages/favorites_screen.dart';
import 'package:dairymart/features/orders/presentation/pages/orders_screen.dart';
import 'package:dairymart/features/settings/presentation/pages/settings_page.dart';
import 'package:dairymart/features/products/presentation/pages/products_page.dart';

// Local Imports
import 'package:dairymart/features/dashboard/presentation/widgets/app_drawer.dart';
import 'package:dairymart/features/dashboard/presentation/providers/dashboard_provider.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(dashboardIndexProvider);

    void onItemTapped(int index) {
      ref.read(dashboardIndexProvider.notifier).state = index;
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      // Add Drawer here
      drawer: AppDrawer(
        selectedIndex: selectedIndex,
        onItemTapped: onItemTapped,
      ),
      // IndexedStack keeps the state of pages alive
      body: IndexedStack(
        index: selectedIndex,
        children: const [
          HomeScreen(), 
          ProductsPage(),
          FavoritesScreen(),
          OrdersScreen(),
          SettingsPage(),
        ],
      ),
    );
  }
}


