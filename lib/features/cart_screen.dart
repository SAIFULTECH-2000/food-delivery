import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/theme/app_theme.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> cartItems = [];
  bool isLoading = true;
  bool hasSufficientBalance = false;
  String selectedMethod = 'pickup'; // 'pickup' or 'delivery'
  String paymentMethod = 'shopeepay'; // 'shopeepay' or 'stripe'

  double deliveryFee = 0.0;
  String restaurantName = 'Unknown Restaurant';

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final cartSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('cart')
        .get();

    setState(() {
      cartItems = cartSnapshot.docs.map((doc) {
        restaurantName = doc['restaurantName'] ?? 'Unknown Restaurant';
        return {
          'name': doc['name'],
          'price': doc['price'],
          'quantity': doc['quantity'],
          'imageUrl': doc['imageUrl'],
        };
      }).toList();
      isLoading = false;
      hasSufficientBalance = true; // simulate balance
    });
  }

  void updateDeliveryMethod(String method) {
    setState(() {
      selectedMethod = method;
      deliveryFee = method == 'pickup' ? 0.0 : 5.00;
    });
  }

  void updatePaymentMethod(String method) {
    setState(() {
      paymentMethod = method;
    });
  }

  @override
  Widget build(BuildContext context) {
    double itemTotal = cartItems.fold(
      0.0,
      (sum, item) => sum + (item['price'] * item['quantity']),
    );
    double totalWithDelivery = itemTotal + deliveryFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Order', style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.accentGreen,
        foregroundColor: Colors.black,
      ),
      backgroundColor: AppTheme.canvasCream,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (selectedMethod == 'pickup')
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Text(
                      'Pickup Address:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ListTile(
                  leading: const Icon(Icons.storefront, color: Colors.red),
                  title: Text(restaurantName),
                  subtitle: const Text('Pickup Location will be shown here'),
                  trailing: PopupMenuButton<String>(
                    icon: const Icon(Icons.chevron_right),
                    onSelected: updateDeliveryMethod,
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'pickup', child: Text('Pickup Now')),
                      PopupMenuItem(value: 'delivery', child: Text('Order For Later')),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(
                        selectedMethod == 'pickup'
                            ? 'Pickup Now - Ready in 5 minutes'
                            : 'Delivery - Estimated in 30-45 minutes',
                      ),
                    ],
                  ),
                ),
                const Divider(height: 20),

                // Cart Items
                Expanded(
                  child: cartItems.isEmpty
                      ? const Center(child: Text('Your cart is empty.'))
                      : ListView.builder(
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cartItems[index];
                            return ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item['imageUrl'],
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.image),
                                ),
                              ),
                              title: Text(item['name']),
                              subtitle: Text('RM ${item['price']} x ${item['quantity']}'),
                              trailing: Text(
                                'RM ${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: AppTheme.accentGreen,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                ),

                // Order Summary
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTotalRow('Item Total', 'RM ${itemTotal.toStringAsFixed(2)}'),
                      _buildTotalRow('Delivery Fee', 'RM ${deliveryFee.toStringAsFixed(2)}'),
                      const Divider(),
                      _buildTotalRow(
                        'Grand Total',
                        'RM ${totalWithDelivery.toStringAsFixed(2)}',
                        isBold: true,
                      ),
                      const SizedBox(height: 16),

                      const Text('Payment Method:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          const SizedBox(width: 8),
                          ChoiceChip(
                            label: const Text('Stripe'),
                            selected: paymentMethod == 'stripe',
                            onSelected: (_) => updatePaymentMethod('stripe'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: (paymentMethod == 'shopeepay' && !hasSufficientBalance)
                              ? null
                              : () {
                                  Navigator.pushNamed(context, '/payment');
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentGreen,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            selectedMethod == 'pickup'
                                ? 'Place Pickup Order'
                                : 'Place Delivery Order',
                            style: const TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildTotalRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : null)),
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : null)),
        ],
      ),
    );
  }
}
