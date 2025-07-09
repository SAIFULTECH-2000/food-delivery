import 'package:flutter/material.dart';

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
    if (!mounted) return; // <-- Check if widget is still mounted
    Navigator.pushReplacementNamed(context, '/login');
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F0), // light cream background
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Logo section
            Column(
              children: [
                Image.asset(
                  'assets/aimst_food_hub_logo.png', // replace with your actual asset path
                  width: 200,
                ),
              ],
            ),
            const SizedBox(height: 40),
            // Illustration section
            Image.asset(
              'assets/accessibility_people.png', // replace with your illustration asset
              width: 300,
            ),
            const SizedBox(height: 40),
            // Description text
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "This content includes alt text and speech descriptions to make images accessible for users with visual or hearing impairments, allowing screen readers to convey visual context.",
                style: TextStyle(
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
