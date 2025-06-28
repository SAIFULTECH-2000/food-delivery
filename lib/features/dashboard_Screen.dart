import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/theme/app_theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.canvasCream,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Top section: logo and profile
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/aimst_food_hub_logo.png',
                      height: 80,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/profile');
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage('assets/profile.png'),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Buttons Grid
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
                      label: 'MENU',
                      onTap: () {
                        Navigator.pushNamed(context, '/menu');
                      },
                    ),
                    _DashboardButton(
                      icon: 'assets/order.png',
                      label: 'MY ORDER',
                      onTap: () {
                        Navigator.pushNamed(context, '/myOrder');
                      },
                    ),
                    _DashboardButton(
                      icon: 'assets/notifications.png',
                      label: 'NOTIFICATIONS',
                      onTap: () {
                        Navigator.pushNamed(context, '/notifications');
                      },
                    ),
                    _DashboardButton(
                      icon: 'assets/cart.png',
                      label: 'CART',
                      onTap: () {
                        Navigator.pushNamed(context, '/cart');
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Promotions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'PROMOTIONS',
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
            Image.asset(
              icon,
              height: 60,
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
