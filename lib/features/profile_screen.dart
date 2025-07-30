import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_delivery_app/l10n/app_localizations.dart';
import 'package:food_delivery_app/core/theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  String fullName = '';
  String email = '';
  String phone = '';
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
    final loc = AppLocalizations.of(context)!;

    if (data != null) {
      setState(() {
        fullName = data['fullName'] ?? loc.guestUser;
        email = data['email'] ?? loc.guestEmail;
        phone = data['phone'] ?? loc.phoneNA;
        profileImageUrl = data['profileImageUrl'] ?? '';
        isLoading = false;
      });
    } else {
      setState(() {
        fullName = loc.guestUser;
        email = loc.guestEmail;
        phone = loc.phoneNA;
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
      backgroundColor: AppTheme.canvasCream,
      appBar: AppBar(
        backgroundColor: AppTheme.canvasCream,
        elevation: 0,
        title: Text(loc.appName, style: const TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: loc.logoutTooltip,
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: profileImageUrl.isNotEmpty
                    ? NetworkImage(profileImageUrl)
                    : NetworkImage(avatarUrl),
              ),
              const SizedBox(height: 20),
              Text(
                fullName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accentGreen,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                email,
                style: TextStyle(color: Colors.grey[700], fontSize: 16),
              ),
              const SizedBox(height: 6),
              Text(
                phone,
                style: TextStyle(color: Colors.grey[700], fontSize: 16),
              ),
              const SizedBox(height: 40),

              // Order History
              ElevatedButton.icon(
                icon: const Icon(Icons.history),
                label: Text(loc.orderHistory),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentGreen,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () =>
                    Navigator.of(context).pushNamed('/orderHistory'),
              ),
              const SizedBox(height: 20),

              // Settings
              ElevatedButton.icon(
                icon: const Icon(Icons.settings),
                label: Text(
                  loc.settings,
                ), // Add 'settings' to your localization
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppTheme.accentGreen,
                  side: const BorderSide(color: AppTheme.accentGreen),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () =>
                    Navigator.of(context).pushNamed('/editProfile'),
              ),
              const SizedBox(height: 20),

              // Rewards Member Points
              ElevatedButton.icon(
                icon: const Icon(Icons.card_giftcard),
                label: const Text("Rewards Member Points"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppTheme.accentGreen,
                  side: const BorderSide(color: AppTheme.accentGreen),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('/rewards');
                },
              ),
              const SizedBox(height: 20),

              // Subscription
              ElevatedButton.icon(
                icon: const Icon(Icons.subscriptions),
                label: const Text("Subscription"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppTheme.accentGreen,
                  side: const BorderSide(color: AppTheme.accentGreen),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('/subscription');
                },
              ),
              const SizedBox(height: 20),

              // Help / Contact Support
              ElevatedButton.icon(
                icon: const Icon(Icons.support_agent),
                label: const Text("Help / Contact Support"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppTheme.accentGreen,
                  side: const BorderSide(color: AppTheme.accentGreen),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('/support');
                },
              ),
              const SizedBox(height: 20),

              ElevatedButton.icon(
                icon: const Icon(Icons.credit_card),
                label: const Text("Payment Method"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppTheme.accentGreen,
                  side: const BorderSide(color: AppTheme.accentGreen),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('/paymentMethod');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
