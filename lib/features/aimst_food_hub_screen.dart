import 'package:flutter/material.dart';
import 'package:food_delivery_app/l10n/app_localizations.dart';

class AimstFoodHubScreen extends StatefulWidget {
  const AimstFoodHubScreen({super.key});

  @override
  State<AimstFoodHubScreen> createState() => _AimstFoodHubScreenState();
}

class _AimstFoodHubScreenState extends State<AimstFoodHubScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F0),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Logo section
            Column(
              children: [
                Image.asset(
                  'assets/aimst_food_hub_logo.png',
                  width: 200,
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Illustration section
            Image.asset(
              'assets/accessibility_people.png',
              width: 300,
            ),

            const SizedBox(height: 40),

            // Description (localized)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                AppLocalizations.of(context)!.introDescription,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
