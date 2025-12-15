import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final primaryBlue = const Color(0xFF29ABE2);
  int _selectedIndex = 0; // Tracks which tab is active

  // Handles tab clicks
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
      // We will simply switch the body content based on the index later. 
      // For now, we keep the main dashboard visible.
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))
                  ]
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search milk, butter, cheese...",
                    hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryBlue, const Color(0xFF63C6F7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Fresh Morning!", style: GoogleFonts.poppins(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          Text("Get 20% off on your first order of fresh milk.", style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.9))),
                        ],
                      ),
                    ),
                    const Icon(Icons.local_drink_rounded, color: Colors.white, size: 60),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // Categories
              Text("Categories", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 15),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryItem("Milk", Icons.water_drop, primaryBlue),
                    _buildCategoryItem("Cheese", Icons.circle_outlined, Colors.orange),
                    _buildCategoryItem("Butter", Icons.breakfast_dining, Colors.yellow[700]!),
                    _buildCategoryItem("Yogurt", Icons.icecream_outlined, Colors.pink),
                    _buildCategoryItem("Cream", Icons.cake_outlined, Colors.purpleAccent),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // Products Grid
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
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10)]
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Center(child: Icon(Icons.image_not_supported_outlined, size: 60, color: Colors.grey[300])),
                        ),
                        const SizedBox(height: 10),
                        Text("Fresh Milk 1L", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text("Organic Farm", style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("\$2.50", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: primaryBlue, fontSize: 16)),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(color: primaryBlue, shape: BoxShape.circle),
                              child: const Icon(Icons.add, color: Colors.white, size: 16),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex, // UPDATED: Connected to state
        onTap: _onItemTapped,         // UPDATED: Connected to handler
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: "Orders"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String title, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 15),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15)
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(title, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}