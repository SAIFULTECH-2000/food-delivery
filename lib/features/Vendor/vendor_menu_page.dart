import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VendorMenuPage extends StatelessWidget {
  final String vendorEmail; // The vendor's email

  const VendorMenuPage({super.key, required this.vendorEmail});

  @override
  Widget build(BuildContext context) {
    final vendorStream = FirebaseFirestore.instance
        .collection('vendors')
        .where('email', isEqualTo: vendorEmail)
        .limit(1)
        .snapshots();

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: vendorStream,
        builder: (context, vendorSnapshot) {
          if (vendorSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!vendorSnapshot.hasData || vendorSnapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Vendor not found.'));
          }

          // Get vendor document ID
          final vendorDoc = vendorSnapshot.data!.docs.first;
          final vendorId = vendorDoc.id;

          // Foods stream
          final foodsStream = FirebaseFirestore.instance
              .collection('vendors')
              .doc(vendorId)
              .collection('foods')
              .snapshots();

          return StreamBuilder<QuerySnapshot>(
            stream: foodsStream,
            builder: (context, foodSnapshot) {
              if (foodSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!foodSnapshot.hasData || foodSnapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No food items found.'));
              }

              final foods = foodSnapshot.data!.docs;

              return ListView.builder(
                itemCount: foods.length,
                itemBuilder: (context, index) {
                  final food = foods[index];
                  final name = food['name'] ?? 'Unnamed';
                  final price = food['price']?.toDouble() ?? 0.0;
                  final imageUrl = food['imageUrl'] ?? '';
                  final isAvailable = food['isAvailable'] ?? true;

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: imageUrl.isNotEmpty
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(imageUrl),
                            )
                          : const Icon(Icons.fastfood),
                      title: Text(name),
                      subtitle: Text('RM ${price.toStringAsFixed(2)}'),
                      trailing: isAvailable
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.remove_circle, color: Colors.red),
                      onTap: () {
                        _showFoodPopup(
                          context,
                          vendorId,
                          food.id,
                          name,
                          price,
                          imageUrl,
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showFoodPopup(
    BuildContext context,
    String vendorId,
    String foodId,
    String name,
    double price,
    String imageUrl,
  ) {
    final controller = TextEditingController(text: price.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 12),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Price (RM)",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final newPrice = double.tryParse(controller.text);
                if (newPrice != null) {
                  await FirebaseFirestore.instance
                      .collection('vendors')
                      .doc(vendorId)
                      .collection('foods')
                      .doc(foodId)
                      .update({'price': newPrice});
                }
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
