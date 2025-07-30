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
          final orderTime = (orderData['createdAt'] as Timestamp).toDate();
          final int currentStep = _getStatusIndex(orderTime);
          final String gifUrl = _getGifByStatus(currentStep);

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
                    _buildStep('Restaurant is making your order', 0, currentStep),
                    _buildStep('Driver picked up food', 1, currentStep),
                    _buildStep('Driver arrived at your home', 2, currentStep),
                    _buildStep('Enjoy your meal!', 3, currentStep),
                  ],
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: (currentStep + 1) / 4,
                  color: AppTheme.accentGreen,
                  backgroundColor: Colors.grey[300],
                ),
                const SizedBox(height: 20),

                // Status GIF
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    gifUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image, size: 50)),
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

  String _getGifByStatus(int step) {
    switch (step) {
      case 0:
        return 'https://i.pinimg.com/originals/93/5e/f3/935ef3e9c164fe37ddde01ccd8cec4ba.gif';
      case 1:
        return 'https://media4.giphy.com/media/v1.Y2lkPTZjMDliOTUyeXl0dXZzenJyOWZlam9xeWpoOTZveXlwZngxamhtYWs3OW5kaWRrNiZlcD12MV9naWZzX3NlYXJjaCZjdD1n/ZaovLymRWG8NY9w0DD/source.gif';
      case 2:
        return 'https://i.pinimg.com/originals/d3/18/13/d3181322e4522cf897fa8c1a038c6a2d.gif';
      case 3:
      default:
        return 'https://media.tenor.com/aOzZWYzAmsMAAAAM/yummy-food-mocha-bears.gif';
    }
  }
}
