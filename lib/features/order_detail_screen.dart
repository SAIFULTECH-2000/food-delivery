import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/theme/app_theme.dart';

class OrderDetailScreen extends StatelessWidget {
  final String orderId = '11234';
  final int currentStep = 2; // 0: Order Received, 1: Preparing, 2: Out for Delivery, 3: Delivered

  final List<Map<String, dynamic>> orderHistory = [
    {
      'name': 'Fried Noodles',
      'quantity': 2,
    },
    {
      'name': 'Milo Ice',
      'quantity': 1,
    },
  ];

  OrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.canvasCream,
      appBar: AppBar(
        backgroundColor: AppTheme.canvasCream,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order ID
            Text(
              'Order $orderId',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Progress tracker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStep('Order Received', 0),
                _buildStep('Preparing', 1),
                _buildStep('Out for Delivery', 2),
                _buildStep('Delivered', 3),
              ],
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: (currentStep + 1) / 4,
              color: AppTheme.accentGreen,
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(height: 20),

            // Map placeholder
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(
                child: Icon(Icons.map, size: 50, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),

            // Order history title
            const Text(
              'ORDER HISTORY',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),

            // Order history items
            Expanded(
              child: ListView.builder(
                itemCount: orderHistory.length,
                itemBuilder: (context, index) {
                  final item = orderHistory[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(item['name']),
                      subtitle: Text('${item['quantity']} time'),
                      trailing: TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${item['name']} reordered')),
                          );
                        },
                        child: const Text('Reorder'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String title, int step) {
    bool isCompleted = step <= currentStep;

    return Column(
      children: [
        Icon(
          isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isCompleted ? AppTheme.accentGreen : Colors.grey,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            color: isCompleted ? Colors.black : Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
