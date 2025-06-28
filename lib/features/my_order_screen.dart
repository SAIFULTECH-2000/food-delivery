import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/theme/app_theme.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  final List<Map<String, dynamic>> orders = [
    {
      'restaurantName': 'Nasi Kandar Ali',
      'date': '2025-06-27',
      'status': 'Driver arrived at your home',
      'items': [
        {
          'name': 'Sambal Chicken',
          'image': '/sambal_chicken.jpg',
        },
        {
          'name': 'Fried Noodles',
          'image': '/fried_noodles.jpg',
        },
      ],
    },
    {
      'restaurantName': 'KFC AIMST',
      'date': '2025-06-26',
      'status': 'Restaurant is making your order',
      'items': [
        {
          'name': 'Zinger Burger',
          'image': '/zinger_burger.jpg',
        },
        {
          'name': 'Milo Ice',
          'image': '/milo_ice.png',
        },
      ],
    },
  ];

  final List<String> statusSteps = [
    'Restaurant is making your order',
    'Driver picked up food',
    'Driver arrived at your home',
    'Completed',
  ];

  int _getStatusIndex(String status) {
    return statusSteps.indexOf(status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.canvasCream,
      appBar: AppBar(
        backgroundColor: AppTheme.canvasCream,
        elevation: 0,
        title: const Text(
          'My Orders',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          final currentStatusIndex = _getStatusIndex(order['status']);

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/orderDetail');
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
                          order['restaurantName'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          order['date'],
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
                        children: order['items'].map<Widget>((item) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    item['image'],
                                    height: 40,
                                    width: 40,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item['name'],
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

                    // Progress bar status like GrabFood
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: statusSteps.asMap().entries.map((entry) {
                        int stepIndex = entry.key;
                        String step = entry.value;
                        bool isCompleted = stepIndex <= currentStatusIndex;

                        return Row(
                          children: [
                            Icon(
                              isCompleted
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: isCompleted
                                  ? AppTheme.accentGreen
                                  : Colors.grey,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              step,
                              style: TextStyle(
                                color: isCompleted
                                    ? Colors.black
                                    : Colors.grey[600],
                                fontWeight: isCompleted
                                    ? FontWeight.bold
                                    : FontWeight.normal,
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
      ),
    );
  }
}
