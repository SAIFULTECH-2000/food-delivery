import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/theme/app_theme.dart';

class CartScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems = [
    {
      'name': 'Sambal Chicken',
      'price': 12.0,
      'quantity': 1,
      'image': '/sambal_chicken.jpg',
    },
    {
      'name': 'Fried Noodles',
      'price': 8.0,
      'quantity': 2,
      'image': '/fried_noodles.jpg',
    },
  ];

  CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double totalPrice = cartItems.fold(0.0, (sum, item) => sum + item['price'] * item['quantity']);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        backgroundColor: AppTheme.canvasCream,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      backgroundColor: AppTheme.canvasCream,
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: cartItems.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(item['image'], height: 50, width: 50, fit: BoxFit.cover),
                  ),
                  title: Text(item['name']),
                  subtitle: Text('RM ${item['price']} x ${item['quantity']}'),
                  trailing: Text(
                    'RM ${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('RM ${totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentGreen,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/payment');
                    },
                    child: const Text('Proceed to Payment'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
