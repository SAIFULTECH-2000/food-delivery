import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/features/OrderChatScreen.dart';
import 'package:intl/intl.dart';
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
            .collection('myOrders')
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
          final orderTime =
              (orderData['date'] as Timestamp?)?.toDate() ?? DateTime.now();
          final int currentStep = _getStatusIndex(orderTime);
          final String gifUrl = _getGifByStatus(currentStep);
          final items = Map<String, dynamic>.from(orderData['items'] ?? {});

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order #${orderId.substring(orderId.length - 4)}',
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OrderChatScreen(
                              orderId: orderId, // you already have this
                            ),
                          ),
                        );
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

                // Progress Tracker
                _buildProgressTracker(currentStep),

                const SizedBox(height: 30),

                // Status GIF
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
                  'Order Items',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),

                const SizedBox(height: 12),

                // Items List
                ...items.entries.map((entry) {
                  final item = entry.value as Map<String, dynamic>;
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/images/placeholder.png',
                            image: item['imageUrl'] ?? '',
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                            imageErrorBuilder: (_, __, ___) => const Icon(
                              Icons.fastfood,
                              size: 30,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        title: Text(
                          item['name'] ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                        subtitle: Text('Qty: ${item['quantity']}'),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("RM${item['price']}"),
                            const SizedBox(height: 4),

                            GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${item['name']} reordered successfully',
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'Reorder',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),

                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Total: RM${orderData['totalPrice'] ?? 0}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
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
              // Consistent circle for all states
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isCompleted
                      ? LinearGradient(
                          colors: [AppTheme.accentGreen, Colors.greenAccent],
                        )
                      : LinearGradient(
                          colors: [Colors.grey.shade300, Colors.grey.shade200],
                        ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    isCompleted ? Icons.check : Icons.circle_outlined,
                    color: isCompleted ? Colors.white : Colors.grey,
                    size: 18, // fixed size for alignment
                  ),
                ),
              ),

              const SizedBox(height: 8),

              SizedBox(
                width: 70,
                child: Text(
                  steps[stepIndex],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isCompleted ? Colors.black87 : Colors.grey,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        } else {
          final lineActive = (index ~/ 2) < currentStep;
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: lineActive
                    ? LinearGradient(
                        colors: [AppTheme.accentGreen, Colors.greenAccent],
                      )
                    : LinearGradient(
                        colors: [Colors.grey.shade300, Colors.grey.shade200],
                      ),
              ),
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
