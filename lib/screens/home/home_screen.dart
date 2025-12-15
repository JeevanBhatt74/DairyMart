import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- IMPORT THE SEPARATE FILES ---
// Adjust the path '../' means go up one folder, then into the specific folder
import '../favorites/favorites_screen.dart'; // Ensure this file exists too!
import '../orders/orders_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final primaryBlue = const Color(0xFF29ABE2);
  int _selectedIndex = 0; 

  // Define the pages here
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomeContent(),     // Defined at bottom of this file
      const FavoritesScreen(), // From favorites_screen.dart
      const OrdersScreen(),    // From orders_screen.dart
      const ProfileScreen(),   // From profile_screen.dart
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: "Orders"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }
}

// --- DASHBOARD CONTENT WIDGET ---
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});
  final primaryBlue = const Color(0xFF29ABE2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primaryBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.storefront, color: primaryBlue, size: 20),
            ),
            const SizedBox(width: 10),
            Text("DairyMart", style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none_rounded, color: Colors.black87), onPressed: () {}),
          IconButton(icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black87), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeSearchBar(),
              const SizedBox(height: 25),
              PromoBanner(primaryBlue: primaryBlue),
              const SizedBox(height: 25),
              Text("Categories", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 15),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CategoryItem(title: "Milk", icon: Icons.water_drop, color: primaryBlue),
                    CategoryItem(title: "Cheese", icon: Icons.circle_outlined, color: Colors.orange),
                    CategoryItem(title: "Butter", icon: Icons.breakfast_dining, color: Colors.yellow[700]!),
                    CategoryItem(title: "Yogurt", icon: Icons.icecream_outlined, color: Colors.pink),
                    CategoryItem(title: "Cream", icon: Icons.cake_outlined, color: Colors.purpleAccent),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Text("Popular Products", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 15),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return ProductCard(primaryBlue: primaryBlue);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- REUSABLE WIDGETS (Card, Banner, etc.) ---
// (Keep your existing helper widgets here: ProductCard, PromoBanner, HomeSearchBar, CategoryItem)
class ProductCard extends StatelessWidget {
  final Color primaryBlue;
  const ProductCard({super.key, required this.primaryBlue});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Center(child: Icon(Icons.image_not_supported_outlined, size: 60, color: Colors.grey[300]))),
          const SizedBox(height: 10),
          Text("Fresh Milk 1L", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
          Text("Organic Farm", style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 5),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("\$2.50", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: primaryBlue, fontSize: 16)),
            Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: primaryBlue, shape: BoxShape.circle), child: const Icon(Icons.add, color: Colors.white, size: 16))
          ])
        ],
      ),
    );
  }
}

class PromoBanner extends StatelessWidget {
  final Color primaryBlue;
  const PromoBanner({super.key, required this.primaryBlue});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(gradient: LinearGradient(colors: [primaryBlue, const Color(0xFF63C6F7)], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(20)),
      child: Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Fresh Morning!", style: GoogleFonts.poppins(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)), const SizedBox(height: 5), Text("Get 20% off on your first order of fresh milk.", style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.9)))])), const Icon(Icons.local_drink_rounded, color: Colors.white, size: 60)]),
    );
  }
}

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))]),
      child: TextField(decoration: InputDecoration(hintText: "Search milk, butter, cheese...", hintStyle: GoogleFonts.poppins(color: Colors.grey[400]), prefixIcon: const Icon(Icons.search, color: Colors.grey), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15))),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String title; final IconData icon; final Color color;
  const CategoryItem({super.key, required this.title, required this.icon, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(margin: const EdgeInsets.only(right: 15), child: Column(children: [Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(15)), child: Icon(icon, color: color, size: 28)), const SizedBox(height: 8), Text(title, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500))]));
  }
}