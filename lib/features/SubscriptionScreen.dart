import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/theme/app_theme.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeInAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildPlanCard({
    required String title,
    required String price,
    required String description,
    bool isBest = false,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isBest ? AppTheme.accentGreen.withOpacity(0.95) : Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isBest)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "BEST VALUE",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                color: isBest ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: isBest ? Colors.white70 : Colors.black54,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              price,
              style: TextStyle(
                fontSize: 24,
                color: isBest ? Colors.white : AppTheme.accentGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Handle subscription logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isBest ? Colors.white : AppTheme.accentGreen,
                  foregroundColor: isBest ? AppTheme.accentGreen : Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Subscribe"),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeInAnimation,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Subscription Plans"),
          backgroundColor: AppTheme.accentGreen,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              const SizedBox(height: 10),
              const Text(
                "Choose the plan that suits you best.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              buildPlanCard(
                title: "Basic Plan",
                price: "RM9.99 / month",
                description: "Access to standard menu and rewards.",
              ),
              buildPlanCard(
                title: "Pro Plan",
                price: "RM19.99 / month",
                description: "Includes early access to new features and premium items.",
                isBest: true,
              ),
              buildPlanCard(
                title: "Student Plan",
                price: "RM4.99 / month",
                description: "Discounted plan for students (with verification).",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
