import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/theme/app_theme.dart';
import 'package:food_delivery_app/features/order_detail_screen.dart';
import 'package:food_delivery_app/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

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
    final List<String> statusSteps = [
      AppLocalizations.of(context)!.restaurantIsMaking,
      AppLocalizations.of(context)!.driverPickedUp,
      AppLocalizations.of(context)!.driverArrived,
      AppLocalizations.of(context)!.completed,
    ];

    return Scaffold(
      backgroundColor: AppTheme.canvasCream,
      appBar: AppBar(
        backgroundColor: AppTheme.canvasCream,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () =>
              Navigator.pushReplacementNamed(context, '/dashboard'),
        ),
        title: Text(
          AppLocalizations.of(context)!.my_order,
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // You might want to reload data explicitly here or just call setState
          setState(() {});
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: StreamBuilder<QuerySnapshot>(
          stream: _getOrdersStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.noOrdersFound,
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }

            final orders = snapshot.data!.docs;

            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final orderData = orders[index].data() as Map<String, dynamic>;
                final orderTime = (orderData['createdAt'] as Timestamp?)
                    ?.toDate();
                if (orderTime == null) return const SizedBox();

                final currentStatusIndex = _getStatusIndex(orderTime);
                final formattedDate = DateFormat(
                  'dd MMM yyyy, hh:mm a',
                ).format(orderTime);

                // Assuming orderData contains a list of items
                final List<dynamic> items = orderData['items'] ?? [];

                // Calculate total price
                final double totalPrice = items.fold(
                  0,
                  (sum, item) => sum + (item['price'] ?? 0),
                );

                return Material(
                  elevation: 3,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  OrderDetailScreen(orderId: orders[index].id),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                                final offsetAnimation = Tween<Offset>(
                                  begin: const Offset(1.0, 0.0),
                                  end: Offset.zero,
                                ).animate(animation);
                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                                );
                              },
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Restaurant name + date + total price
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  orderData['restaurantName'] ??
                                      'Unknown Restaurant',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    formattedDate,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\$${totalPrice.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: AppTheme.accentGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Horizontal thumbnails of items ordered
                          SizedBox(
                            height: 70,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: items.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 12),
                              itemBuilder: (context, idx) {
                                final item = items[idx];
                                return Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        item['imageUrl'] ?? '',
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(
                                              Icons.fastfood,
                                              size: 50,
                                              color: Colors.grey,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    SizedBox(
                                      width: 50,
                                      child: Text(
                                        item['name'] ?? '',
                                        style: const TextStyle(fontSize: 10),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Status steps horizontal progress indicator
                          SizedBox(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: statusSteps.asMap().entries.map((
                                entry,
                              ) {
                                final stepIndex = entry.key;
                                final step = entry.value;
                                final isCompleted =
                                    stepIndex <= currentStatusIndex;
                                final isCurrent =
                                    stepIndex == currentStatusIndex;

                                return Expanded(
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 14,
                                        backgroundColor: isCompleted
                                            ? AppTheme.accentGreen
                                            : Colors.grey[300],
                                        child: isCompleted
                                            ? const Icon(
                                                Icons.check,
                                                size: 18,
                                                color: Colors.white,
                                              )
                                            : Text(
                                                '${stepIndex + 1}',
                                                style: TextStyle(
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                      ),

                                      Text(
                                        step,
                                        style: TextStyle(
                                          fontSize: 8,
                                          fontWeight: isCurrent
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: isCompleted
                                              ? Colors.black
                                              : Colors.grey[600],
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2, // Limit to 2 lines max
                                        overflow: TextOverflow
                                            .ellipsis, // prevent overflow
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
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
