import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/theme/app_theme.dart';
import 'package:food_delivery_app/features/order_detail_screen.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  final List<String> statusSteps = [
    'Restaurant is making your order',
    'Driver picked up food',
    'Driver arrived at your home',
    'Completed',
  ];

  int _getStatusIndex(DateTime orderTime) {
    final secondsElapsed = DateTime.now().difference(orderTime).inSeconds;
    if (secondsElapsed < 20) return 0;
    if (secondsElapsed < 40) return 1;
    if (secondsElapsed < 60) return 2;
    if (secondsElapsed < 90) return 3;
    return 3;
  }

  Stream<QuerySnapshot> _getOrdersStream() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('myorder')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.canvasCream,
      appBar: AppBar(
        backgroundColor: AppTheme.canvasCream,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/dashboard');
          },
        ),
        title: const Text(
          'My Orders',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: StreamBuilder<QuerySnapshot>(
          stream: _getOrdersStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No orders found'));
            }

            final orders = snapshot.data!.docs;

            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final orderData = orders[index].data() as Map<String, dynamic>;
                final orderTime = (orderData['createdAt'] as Timestamp?)?.toDate();
                if (orderTime == null) return const SizedBox();

                final currentStatusIndex = _getStatusIndex(orderTime);
                final formattedDate =
                    '${orderTime.year}-${orderTime.month.toString().padLeft(2, '0')}-${orderTime.day.toString().padLeft(2, '0')}';

                final List<dynamic> items = [orderData];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: InkWell(
                    onTap: () {
                   Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => OrderDetailScreen(orderId: orders[index].id),
  ),
);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Restaurant name and date
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                orderData['restaurantName'] ?? 'Unknown',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                formattedDate,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Order items thumbnails
                          SizedBox(
                            height: 60,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: items.map<Widget>((item) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          item['imageUrl'] ?? '',
                                          height: 40,
                                          width: 40,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 40),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        item['name'] ?? '',
                                        style: const TextStyle(fontSize: 10),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Progress bar status
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: statusSteps.asMap().entries.map((entry) {
                              int stepIndex = entry.key;
                              String step = entry.value;
                              bool isCompleted = stepIndex <= currentStatusIndex;

                              return Row(
                                children: [
                                  Icon(
                                    isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                                    color: isCompleted ? AppTheme.accentGreen : Colors.grey,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    step,
                                    style: TextStyle(
                                      color: isCompleted ? Colors.black : Colors.grey[600],
                                      fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
