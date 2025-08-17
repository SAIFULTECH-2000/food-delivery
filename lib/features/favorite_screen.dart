import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  String? uid;
  bool isLoading = true;
  List<Map<String, dynamic>> favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    uid = user.uid;

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('favorites')
          //.orderBy('addedAt', descending: true) // optional
          .get();

      final items = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      setState(() {
        favorites = items;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading favorites: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _reorderItem(Map<String, dynamic> item) async {
    if (uid == null) return;

    try {
      final ordersRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('orders');

      await ordersRef.add({
        'name': item['name'],
        'price': item['price'],
        'imageUrl': item['imageUrl'],
        'category': item['category'],
        'quantity': 1,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${item['name']} added to orders")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("My Favorites")),
      body: favorites.isEmpty
          ? const Center(child: Text("No favorites yet."))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final data = favorites[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: data['imageUrl'] != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              data['imageUrl'],
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.fastfood, size: 40),
                            ),
                          )
                        : const Icon(Icons.fastfood, size: 40),
                    title: Text(data['name'] ?? 'Unnamed'),
                    subtitle: Text(
                      "RM ${data['price']?.toStringAsFixed(2) ?? '0.00'} • ${data['category'] ?? ''}",
                    ),
                    trailing: ElevatedButton(
                      onPressed: () => _reorderItem(data),
                      child: const Text("Reorder"),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
