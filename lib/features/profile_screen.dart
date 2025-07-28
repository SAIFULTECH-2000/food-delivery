import 'package:flutter/material.dart';
import 'package:food_delivery_app/l10n/app_localizations.dart';
import 'package:food_delivery_app/core/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  late SharedPreferences prefs;

  String fullName = '';
  String email = '';
  String phone = '';
  String profileImageUrl = '';
  bool isLoading = true;
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    final currentUser = FirebaseAuth.instance.currentUser;
    userId = currentUser?.uid;
  }

  Future<void> _loadUserProfile() async {
    prefs = await SharedPreferences.getInstance();
    final loc = AppLocalizations.of(context)!;

    setState(() {
      fullName = prefs.getString('fullName') ?? loc.guestUser;
      email = prefs.getString('email') ?? loc.guestEmail;
      phone = prefs.getString('phone') ?? loc.phoneNA;
      profileImageUrl = prefs.getString('profileImageUrl') ?? '';
      isLoading = false;
    });
  }

  Future<void> _logout() async {
    await prefs.clear();
    await FirebaseAuth.instance.signOut();
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final avatarUrl = 'https://api.dicebear.com/9.x/pixel-art/png?seed=${Uri.encodeComponent(userId ?? fullName)}';

    return Scaffold(
      backgroundColor: AppTheme.canvasCream,
      appBar: AppBar(
        backgroundColor: AppTheme.canvasCream,
        elevation: 0,
        title: Text(
          loc.appName,
          style: const TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: loc.logoutTooltip,
            onPressed: _logout,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
              onPressed: () => Navigator.of(context).pushNamed('/orderHistory'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: Text(loc.editProfile),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppTheme.accentGreen,
                side: const BorderSide(color: AppTheme.accentGreen),
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () => Navigator.of(context).pushNamed('/editProfile'),
            ),
          ],
        ),
      ),
    );
  }
}
