import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/theme/app_theme.dart';
import 'package:local_auth/local_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    // Start fade-in animation
    Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    // Start auth logic after 3 seconds
    Timer(const Duration(seconds: 3), () {
      _handleAuthenticationLogic();
    });
  }

  Future<void> _handleAuthenticationLogic() async {
    final user = FirebaseAuth.instance.currentUser;
    const vendorEmails = {
      'kopitiam@aimst.com',
      'aroma@aimst.com',
      'agathiyan@aimst.com',
      'jaya@aimst.com',
    };
    if (user == null) {
      // Not logged in → go to info
      Navigator.pushReplacementNamed(context, '/info');
      return;
    }

    final auth = LocalAuthentication();
    try {
      bool canCheck = await auth.canCheckBiometrics;
      bool isSupported = await auth.isDeviceSupported();

      if (canCheck && isSupported) {
        bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Please scan your fingerprint to continue',
          options: const AuthenticationOptions(
            biometricOnly: true,
            stickyAuth: true,
          ),
        );
        String destinationScreen = vendorEmails.contains(user.email)
            ? '/vendorPage'
            : '/dashboard';
        if (didAuthenticate) {
          Navigator.pushReplacementNamed(context, destinationScreen);
        } else {
          // Authentication failed or cancelled
          _showSnackBar('Fingerprint authentication failed');
          Navigator.pushReplacementNamed(context, '/info');
        }
      } else {
        // Device doesn't support biometrics → go to info
        Navigator.pushReplacementNamed(context, '/info');
      }
    } catch (e) {
      _showSnackBar('Error during authentication: $e');
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.accentGreen,
      body: Center(
        child: AnimatedOpacity(
          duration: const Duration(seconds: 2),
          opacity: _opacity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/aimst_food_hub_logo.png', height: 120),
              const SizedBox(height: 16),
              const Text(
                'AIMST Food Hub',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
