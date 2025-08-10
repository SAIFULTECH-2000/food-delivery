import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // for formatting dates
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
        title: const Text(
          'Order Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
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
            return const Center(
              child: Text('Order not found.', style: TextStyle(fontSize: 16)),
            );
          }

          final orderData = snapshot.data!.data() as Map<String, dynamic>;
          final orderTime = (orderData['createdAt'] as Timestamp).toDate();
          final int currentStep = _getStatusIndex(orderTime);
          final String gifUrl = _getGifByStatus(currentStep);

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order ID: ${orderId.length > 4 ? orderId.substring(orderId.length - 4) : orderId}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.green,
                        size: 28,
                      ),
                      onPressed: () {
                        // Your chat action here
                        print('Chat icon tapped');
                      },
                      tooltip: 'Chat with Restaurant',
                    ),
                  ],
                ),

                const SizedBox(height: 6),
                Text(
                  'Ordered on ${DateFormat.yMMMMd().add_jm().format(orderTime)}',
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                ),

                const SizedBox(height: 24),

                // Progress Tracker - Custom horizontal stepper with lines
                _buildProgressTracker(currentStep),

                const SizedBox(height: 30),

                // Status GIF with shadow & rounded corners
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      gifUrl,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return SizedBox(
                          height: 180,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                      errorBuilder: (_, __, ___) => const SizedBox(
                        height: 180,
                        child: Center(
                          child: Icon(
                            Icons.broken_image,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  'Order History',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),

                const SizedBox(height: 12),

                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: FadeInImage.assetNetwork(
                          placeholder:
                              'assets/images/placeholder.png', // add a placeholder asset
                          image: orderData['imageUrl'] ?? '',
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                          imageErrorBuilder: (_, __, ___) => const Icon(
                            Icons.image,
                            size: 60,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      title: Text(
                        orderData['name'] ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text('${orderData['quantity']} x'),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${orderData['name']} reordered'),
                            ),
                          );
                        },
                        child: const Text(
                          'Reorder',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
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

  Widget _buildProgressTracker(int currentStep) {
    final steps = [
      'Restaurant is\nmaking your order',
      'Driver picked\nup food',
      'Driver arrived\nat your home',
      'Enjoy\nyour meal!',
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(steps.length * 2 - 1, (index) {
        if (index.isEven) {
          final stepIndex = index ~/ 2;
          final isCompleted = stepIndex <= currentStep;
          return Column(
            children: [
              Icon(
                isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isCompleted ? AppTheme.accentGreen : Colors.grey,
                size: 24,
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: 60,
                child: Text(
                  steps[stepIndex],
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isCompleted ? Colors.black : Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        } else {
          // Connecting line between steps
          final lineActive = (index ~/ 2) < currentStep;
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
              height: 4,
              color: lineActive ? AppTheme.accentGreen : Colors.grey[300],
            ),
          );
        }
      }),
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
