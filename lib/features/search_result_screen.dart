import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/features/FoodDetailScreen.dart';

class SearchResultScreen extends StatelessWidget {
  final String query;
  const SearchResultScreen({super.key, required this.query});

Future<List<Map<String, dynamic>>> fetchMatchingFoods(String query) async {
  final vendorSnapshots = await FirebaseFirestore.instance.collection('vendors').get();
  List<Map<String, dynamic>> matchedFoods = [];

  for (var vendorDoc in vendorSnapshots.docs) {
    final vendorId = vendorDoc.id;

    final foodSnapshots = await FirebaseFirestore.instance
        .collection('vendors')
        .doc(vendorId)
        .collection('foods')
        .get(); // Fetch all foods for this vendor

    for (var food in foodSnapshots.docs) {
      final data = food.data();
      final name = data['name']?.toString().toLowerCase() ?? '';

      // Do case-insensitive match here
      if (name.contains(query.toLowerCase())) {
        data['vendorId'] = vendorId;
        data['foodId'] = food.id;
        matchedFoods.add(data);
      }
    }
  }

  return matchedFoods;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results for "$query"'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchMatchingFoods(query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No food items found.'));
          }

          final foods = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: foods.length,
            itemBuilder: (context, index) {
              final food = foods[index];
              return Card(
  margin: const EdgeInsets.only(bottom: 16),
  child: ListTile(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FoodDetailScreen(foodItem: food),
        ),
      );
    },
    leading: food['imageUrl'] != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              food['imageUrl'],
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          )
        : const Icon(Icons.fastfood),
    title: Text(food['name'] ?? 'No name'),
    subtitle: Text(food['description'] ?? ''),
    trailing: Text('RM ${food['price'].toStringAsFixed(2)}'),
  ),
);
            },
          );
        },
      ),
    );
  }
}
