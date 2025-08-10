import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/features/FoodDetailScreen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, dynamic>> favoriteFoods = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final favSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .get();

    List<Map<String, dynamic>> loadedFoods = [];

    for (var doc in favSnapshot.docs) {
      final vendorId = doc.data()['vendorId'];
      final foodId = doc.data()['foodId'];

      final foodDoc = await FirebaseFirestore.instance
          .collection('vendors')
          .doc(vendorId)
          .collection('foods')
          .doc(foodId)
          .get();

      if (foodDoc.exists) {
        final data = foodDoc.data()!;
        data['vendorId'] = vendorId;
        data['foodId'] = foodId;
        loadedFoods.add(data);
      }
    }

    setState(() {
      favoriteFoods = loadedFoods;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : favoriteFoods.isEmpty
              ? const Center(child: Text('No favorite items yet.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: favoriteFoods.length,
                  itemBuilder: (context, index) {
                    final food = favoriteFoods[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FoodDetailScreen(foodItem: food),
                            ),
                          );
                        },
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            food['imageUrl'],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(food['name'] ?? 'Unnamed'),
                        subtitle: Text(food['description'] ?? ''),
                        trailing: Text('RM ${food['price'].toStringAsFixed(2)}'),
                      ),
                    );
                  },
                ),
    );
  }
}
