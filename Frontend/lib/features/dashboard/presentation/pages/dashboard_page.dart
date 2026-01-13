// Main dashboard with bottom navigation
import 'package:dairymart/features/favorites/presentation/pages/favorites_screen.dart';
import 'package:dairymart/features/orders/presentation/pages/orders_screen.dart';
import 'package:dairymart/features/profile/presentation/pages/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- IMPORTS FOR OTHER TABS ---
// We link these to your Clean Architecture pages

// --- 1. MAIN DASHBOARD (Holds Bottom Nav) ---
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final primaryBlue = const Color(0xFF29ABE2);
  int _selectedIndex = 0;

  // Define the pages for the bottom navigation
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomeView(),       // Your Custom Home Content
      const FavoritesScreen(),  // Clean Arch Favorites Page
      const OrdersScreen(),     // Clean Arch Orders Page
      const ProfileScreen(),    // Clean Arch Profile Page
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
      // IndexedStack keeps the state of pages alive (so scroll position saves)
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedLabelStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
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

// --- 2. HOME VIEW (Your Exact Previous Design) ---
class HomeView extends StatelessWidget {
  const HomeView({super.key});
  
  final primaryBlue = const Color(0xFF29ABE2);

  // --- GENUINE NEPALI DAIRY DATA ---
  static final List<Product> products = [
    Product(
      name: "DDC Milk",
      brand: "DDC Nepal",
      price: "Rs. 110",
      image: "assets/images/milk.jpg",
    ),
    Product(
      name: "Yak Cheese",
      brand: "Himalayan Dairy",
      price: "Rs. 1,200/kg",
      image: "assets/images/cheese.png",
    ),
    Product(
      name: "Fresh Ghee",
      brand: "Sitaram Milk",
      price: "Rs. 950/L",
      image: "assets/images/ghee.png",
    ),
    Product(
      name: "Juju Dhau",
      brand: "Bhaktapur Local",
      price: "Rs. 350",
      image: "assets/images/Juju-Dhau.jpg", // Make sure this file exists!
    ),
    Product(
      name: "Amul Butter",
      brand: "Amul",
      price: "Rs. 580",
      image: "assets/images/butter.jpg",
    ),
    Product(
      name: "Paneer",
      brand: "ND's Organic",
      price: "Rs. 850/kg",
      image: "assets/images/Paneer.jpg", // Make sure this file exists!
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Note: We use a SafeArea here directly instead of another Scaffold
    // to avoid "nested scaffold" issues.
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            children: [
              // --- BRAND LOGO ---
              SizedBox(
                height: 40,
                width: 40,
                child: Image.asset(
                  "assets/images/logo.png",
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.storefront, color: primaryBlue, size: 30),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "DairyMart",
                style: GoogleFonts.poppins(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                )
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none_rounded, color: Colors.black87),
              onPressed: () {}
            ),
            IconButton(
              icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black87),
              onPressed: () {}
            ),
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
                Text(
                  "Categories",
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)
                ),
                const SizedBox(height: 15),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      CategoryItem(title: "Milk", icon: Icons.water_drop, color: primaryBlue),
                      const CategoryItem(title: "Cheese", icon: Icons.circle_outlined, color: Colors.orange),
                      CategoryItem(title: "Butter", icon: Icons.breakfast_dining, color: Colors.yellow[700]!),
                      const CategoryItem(title: "Yogurt", icon: Icons.icecream_outlined, color: Colors.pink),
                      const CategoryItem(title: "Cream", icon: Icons.cake_outlined, color: Colors.purpleAccent),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Text(
                  "Popular Products",
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)
                ),
                const SizedBox(height: 15),
                
                // Using GridView with physics since it's inside SingleChildScrollView
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return ProductCard(
                      primaryBlue: primaryBlue,
                      product: products[index],
                    );
                  },
                ),
                const SizedBox(height: 20), // Bottom padding
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- 3. DATA MODEL ---
class Product {
  final String name;
  final String brand;
  final String price;
  final String image;

  Product({required this.name, required this.brand, required this.price, required this.image});
}

// --- 4. WIDGETS ---

class ProductCard extends StatelessWidget {
  final Color primaryBlue;
  final Product product;

  const ProductCard({super.key, required this.primaryBlue, required this.product});

  @override
  Widget build(BuildContext context) {
    bool isNetworkImage = product.image.startsWith('http');
    const double cardRadius = 15.0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(cardRadius),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(cardRadius),
                child: isNetworkImage
                  ? Image.network(
                      product.image,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                    )
                  : Image.asset(
                      product.image,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 40, color: Colors.red),
                    ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            product.name,
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            product.brand,
            style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                product.price,
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: primaryBlue, fontSize: 14)
              ),
              Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: primaryBlue, shape: BoxShape.circle),
                  child: const Icon(Icons.add, color: Colors.white, size: 16))
            ]
          )
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
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryBlue, const Color(0xFF63C6F7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight
        ),
        borderRadius: BorderRadius.circular(20)
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Fresh Morning!",
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)
                ),
                const SizedBox(height: 5),
                Text(
                  "Get 20% off on your first order of fresh milk.",
                  style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.9))
                )
              ]
            )
          ),
          const Icon(Icons.local_drink_rounded, color: Colors.white, size: 60)
        ]
      ),
    );
  }
}

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))]
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search milk, butter, cheese...",
          hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15)
        )
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  const CategoryItem({super.key, required this.title, required this.icon, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 15),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(15)),
            child: Icon(icon, color: color, size: 28)
          ),
          const SizedBox(height: 8),
          Text(title, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500))
        ]
      )
    );
  }
}