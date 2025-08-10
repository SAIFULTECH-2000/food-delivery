import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_delivery_app/l10n/app_localizations.dart';
import 'package:food_delivery_app/core/theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String fullName = '';
  String email = '';
  String address = '';
  String profileImageUrl = '';
  String? userId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    userId = user.uid;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();
    final data = doc.data();

    if (data != null) {
      setState(() {
        fullName = data['fullName'] ?? 'Guest';
        email = data['email'] ?? 'guest@email.com';
        address = data['address'] ?? 'Unknown address';
        profileImageUrl = data['profileImageUrl'] ?? '';
        isLoading = false;
      });
    } else {
      setState(() {
        fullName = 'Guest';
        email = 'guest@email.com';
        address = 'Unknown address';
        profileImageUrl = '';
        isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final avatarUrl =
        'https://api.dicebear.com/9.x/pixel-art/png?seed=${Uri.encodeComponent(userId ?? fullName)}';

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: AppTheme.accentGreen,
        ), // <-- sets back icon color
        backgroundColor: Theme.of(
          context,
        ).cardColor, // <-- use backgroundColor here
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).pushNamed('/editProfile');
            },
            color: AppTheme.accentGreen,
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            // Profile section
            CircleAvatar(
              radius: 40,
              backgroundImage: profileImageUrl.isNotEmpty
                  ? NetworkImage(profileImageUrl)
                  : NetworkImage(avatarUrl),
            ),
            const SizedBox(height: 12),
            Text(
              fullName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              address,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 20),

            // First Group
            _buildCard([
              _buildTile(Icons.credit_card, "Payments Methods", () {
                Navigator.pushNamed(context, '/paymentMethod');
              }),
              _buildTile(Icons.favorite, "Favorite Order", () {
                Navigator.pushNamed(context, '/favorite');
              }),
            ]),

            const SizedBox(height: 10),

            // Second Group
            _buildCard([
              _buildTile(Icons.list_alt, "My Order", () {
                Navigator.pushNamed(context, '/myOrder');
              }),
              _buildTile(Icons.settings, "Settings", () {
                Navigator.pushNamed(context, '/editProfile');
              }),
              _buildTile(Icons.notifications, "Notification", () {
                Navigator.pushNamed(context, '/notifications');
              }),
            ]),

            const SizedBox(height: 20),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text("Log Out"),
                onPressed: _logout,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        onTap: (index) {
          if (index == 0) Navigator.pushNamed(context, '/home');
          if (index == 1) Navigator.pushNamed(context, '/favorite');
          if (index == 2) Navigator.pushNamed(context, '/cart');
          // 3 is profile
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favourite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
