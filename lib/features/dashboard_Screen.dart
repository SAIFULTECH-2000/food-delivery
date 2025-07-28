import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/theme/app_theme.dart';
import 'package:food_delivery_app/l10n/app_localizations.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  String? userId;
  late List<Widget> _pages;

  int cartCount = 0;

  bool _isPagesInitialized = false;

  @override
  void initState() {
    super.initState();
    fetchCartCount();

    final currentUser = FirebaseAuth.instance.currentUser;
    userId = currentUser?.uid;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isPagesInitialized) {
      _pages = [
        DashboardContent(userId: userId),
        PlaceholderScreen(AppLocalizations.of(context)!.menu),
        PlaceholderScreen(AppLocalizations.of(context)!.my_order),
        PlaceholderScreen(AppLocalizations.of(context)!.notifications),
        PlaceholderScreen(AppLocalizations.of(context)!.profile),
      ];
      _isPagesInitialized = true;
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
    return Scaffold(
      body: userId == null
          ? const Center(child: CircularProgressIndicator())
          : _pages[_selectedIndex],
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
            label: AppLocalizations.of(context)!.dashboard,
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
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$cartCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: AppLocalizations.of(context)!.cart,
          ),

          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_bag),
            label: AppLocalizations.of(context)!.orders,
          ),
        ],
      ),
    );
  }
}

class DashboardContent extends StatelessWidget {
  final String? userId;
  const DashboardContent({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/aimst_food_hub_logo.png', height: 80),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                    child: userId == null
                        ? const CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.grey,
                          )
                        : CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(
                              'https://api.dicebear.com/9.x/pixel-art/png?seed=${Uri.encodeComponent(userId!)}',
                            ),
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
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
                    label: AppLocalizations.of(context)!.menu,
                    onTap: () {
                      Navigator.pushNamed(context, '/vendors');
                    },
                  ),
                  _DashboardButton(
                    icon: 'assets/order.png',
                    label: AppLocalizations.of(context)!.my_order,
                    onTap: () {
                      Navigator.pushNamed(context, '/myOrder');
                    },
                  ),
                  _DashboardButton(
                    icon: 'assets/notifications.png',
                    label: AppLocalizations.of(context)!.notifications,
                    onTap: () {
                      Navigator.pushNamed(context, '/notifications');
                    },
                  ),
                  _DashboardButton(
                    icon: 'assets/cart.png',
                    label: AppLocalizations.of(context)!.cart,
                    onTap: () {
                      Navigator.pushNamed(context, '/cart');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.promotions,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/promo1.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 150,
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
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

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$title Screen',
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
