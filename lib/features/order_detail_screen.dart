import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/theme/app_theme.dart';

class OrderDetailScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: AppTheme.canvasCream,
      appBar: AppBar(
        backgroundColor: AppTheme.canvasCream,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Order Details', style: TextStyle(color: Colors.black)),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('myorder')
            .doc(orderId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Order not found.'));
          }

          final orderData = snapshot.data!.data() as Map<String, dynamic>;

          DateTime orderTime = (orderData['createdAt'] as Timestamp).toDate();
          int currentStep = _getStatusIndex(orderTime);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order ID: $orderId',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Progress Tracker
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStep('Order Received', 0, currentStep),
                    _buildStep('Preparing', 1, currentStep),
                    _buildStep('Out for Delivery', 2, currentStep),
                    _buildStep('Delivered', 3, currentStep),
                  ],
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: (currentStep + 1) / 4,
                  color: AppTheme.accentGreen,
                  backgroundColor: Colors.grey[300],
                ),
                const SizedBox(height: 20),

                // Map Placeholder
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

                const Text(
                  'ORDER HISTORY',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),

                Card(
                  child: ListTile(
                    leading: Image.network(
                      orderData['imageUrl'] ?? '',
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.image),
                    ),
                    title: Text(orderData['name'] ?? ''),
                    subtitle: Text('${orderData['quantity']} time'),
                    trailing: TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${orderData['name']} reordered')),
                        );
                      },
                      child: const Text('Reorder'),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  int _getStatusIndex(DateTime orderTime) {
    final secondsElapsed = DateTime.now().difference(orderTime).inSeconds;
    if (secondsElapsed < 20) return 0;
    if (secondsElapsed < 40) return 1;
    if (secondsElapsed < 60) return 2;
    if (secondsElapsed < 90) return 3;
    return 3;
  }

  Widget _buildStep(String title, int step, int currentStep) {
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
