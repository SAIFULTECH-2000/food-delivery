import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/features/OrderChatScreen.dart';
import 'package:food_delivery_app/features/Vendor/VendorProfilePage.dart';
import 'package:food_delivery_app/features/Vendor/vendor_menu_page.dart';

class VendorHomePage extends StatefulWidget {
  const VendorHomePage({super.key});

  @override
  State<VendorHomePage> createState() => _VendorHomePageState();
}

class _VendorHomePageState extends State<VendorHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  /// 🔥 Stream vendor's orders from Firestore
  Stream<QuerySnapshot> _getVendorOrdersStream(String vendorName) {
    return FirebaseFirestore.instance
        .collection('myOrders')
        .where('restaurantName', isEqualTo: vendorName) // ✅ match vendor name
        .orderBy('date', descending: true)
        .snapshots();
  }

  /// 👇 Popup for order details
  void _showOrderPopup(BuildContext context, DocumentSnapshot orderDoc) {
    final order = orderDoc.data() as Map<String, dynamic>;
    String selectedStatus = order['status'] ?? 'Pending';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Order Details",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // List items
                    ...order['items'].entries.map<Widget>((entry) {
                      final item = entry.value as Map<String, dynamic>;
                      return ListTile(
                        leading: Image.network(
                          item['imageUrl'],
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                        title: Text(item['name']),
                        subtitle: Text(
                          "x${item['quantity']} • RM${item['price']}",
                        ),
                      );
                    }).toList(),

                    const SizedBox(height: 12),
                    Text(
                      "Total: RM${(order['totalPrice'] as num).toStringAsFixed(2)}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 20),

                    // Dropdown for status
                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      decoration: const InputDecoration(
                        labelText: "Order Status",
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "Pending",
                          child: Text("Pending"),
                        ),
                        DropdownMenuItem(
                          value: "Preparing",
                          child: Text("Preparing"),
                        ),
                        DropdownMenuItem(
                          value: "Delivery",
                          child: Text("Delivery"),
                        ),
                        DropdownMenuItem(
                          value: "Completed",
                          child: Text("Completed"),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => selectedStatus = value);
                        }
                      },
                    ),

                    const SizedBox(height: 20),

                    // Update status button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.deepOrange,
                      ),
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('myOrders')
                            .doc(orderDoc.id)
                            .update({'status': selectedStatus});

                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Order updated to $selectedStatus"),
                          ),
                        );
                      },
                      child: const Text("Update Status"),
                    ),

                    const SizedBox(height: 12),

                    // Button to check customer details
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        final customerId =
                            order['userId']; // Make sure your order has this field
                        if (customerId != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderChatScreen(
                                orderId: orderDoc.id, // pass orderId
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Customer info not found"),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.person),
                      label: const Text("View Customer"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildOrdersTab(String vendorName) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: _getVendorOrdersStream(vendorName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No orders yet."));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index].data() as Map<String, dynamic>;

              final customerId = order['userId'] ?? 'Unknown';
              final totalPrice = (order['totalPrice'] as num).toDouble();
              final items = order['items'] as Map<String, dynamic>? ?? {};

              // Show first item image if exists
              String? firstImage;
              if (items.isNotEmpty) {
                final firstItem = items.values.first as Map<String, dynamic>;
                firstImage = firstItem['imageUrl'];
              }

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: () => _showOrderPopup(context, orders[index]),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundImage: firstImage != null
                                  ? NetworkImage(firstImage)
                                  : null,
                              child: firstImage == null
                                  ? const Icon(Icons.fastfood)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Customer: $customerId",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text("Items: ${items.length}"),
                                ],
                              ),
                            ),
                            Text(
                              "RM${totalPrice.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text("Tap to view details"),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text("Not logged in"));
    }

    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('vendors')
          .where('email', isEqualTo: user.email) // or use ownerUid
          .limit(1)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Vendor not found"));
        }

        final vendorDoc = snapshot.data!.docs.first;
        final vendorName = vendorDoc['name'] as String;
        final vendorEmail = vendorDoc['email'] as String;

        switch (_selectedIndex) {
          case 0:
            return _buildOrdersTab(vendorName);
          case 1:
            return VendorMenuPage(vendorEmail: vendorEmail);
          case 2:
            return VendorProfilePage(vendorEmail: vendorEmail);
          default:
            return const Center(child: Text("Page not found"));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendor App', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Orders'),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
