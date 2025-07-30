import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/theme/app_theme.dart';
import 'package:food_delivery_app/features/PromotionsSection.dart';
import 'package:food_delivery_app/l10n/app_localizations.dart';
import 'package:food_delivery_app/main.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  String? userId;
  String profileImageUrl = '';
  String? selectedLanguage;

  int cartCount = 0;

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    userId = currentUser?.uid;
    if (userId != null) {
      fetchUserProfile();
      fetchCartCount();
    }
  }

  Future<void> fetchUserProfile() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final data = doc.data();
    if (data != null) {
      setState(() {
        profileImageUrl = data['profileImageUrl'] ?? '';
        selectedLanguage = data['language'] ?? 'en';
      });
    }
  }

  Future<void> fetchCartCount() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final cartSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('cart')
        .get();

    setState(() {
      cartCount = cartSnapshot.docs.length;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/dashboard');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/cart');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/notifications');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    if (userId == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Top bar with logo, language dropdown, and avatar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('assets/aimst_food_hub_logo.png', height: 40),
                    Row(
                        mainAxisSize: MainAxisSize.min,  // Let Row be as wide as its content

                      children: [
                        SizedBox(
                          width:150,
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.language),
                              labelText: loc.chooseLanguage,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            value: selectedLanguage,
                            items: const [
                              DropdownMenuItem(value: 'en', child: Text('English')),
                              DropdownMenuItem(value: 'ms', child: Text('Malay')),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedLanguage = value;
                                });
                                MyApp.setLocale(context, Locale(value));
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/profile');
                          },
                          child: CircleAvatar(
                            radius: 20,
                            backgroundImage: profileImageUrl.isNotEmpty
                                ? NetworkImage(profileImageUrl)
                                : NetworkImage('https://api.dicebear.com/9.x/pixel-art/png?seed=${Uri.encodeComponent(userId!)}'),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Grid menu buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  children: [
                    _DashboardButton(
                      icon: 'assets/menu.png',
                      label: loc.menu,
                      onTap: () => Navigator.pushNamed(context, '/vendors'),
                    ),
                    _DashboardButton(
                      icon: 'assets/order.png',
                      label: loc.my_order,
                      onTap: () => Navigator.pushNamed(context, '/myOrder'),
                    ),
                    _DashboardButton(
                      icon: 'assets/notifications.png',
                      label: loc.notifications,
                      onTap: () => Navigator.pushNamed(context, '/notifications'),
                    ),
                    _DashboardButton(
                      icon: 'assets/cart.png',
                      label: loc.cart,
                      onTap: () => Navigator.pushNamed(context, '/cart'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Promotions section
             
            const PromotionsSection(),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: loc.dashboard,
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                if (cartCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        '$cartCount',
                        style: const TextStyle(color: Colors.white, fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: loc.cart,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_bag),
            label: loc.orders,
          ),
        ],
      ),
    );
  }
}

class _DashboardButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const _DashboardButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black54),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon, height: 60),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
