import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:food_delivery_app/core/theme/app_theme.dart';
import 'package:food_delivery_app/l10n/app_localizations.dart';
import 'dart:math';

class VendorsScreen extends StatefulWidget {
  const VendorsScreen({super.key});

  @override
  State<VendorsScreen> createState() => _VendorsScreenState();
}

class _VendorsScreenState extends State<VendorsScreen> {
  final Map<String, List<Map<String, dynamic>>> _foodCache = {};

  Future<List<Map<String, dynamic>>> fetchRandomFoods(String vendorId) async {
    if (_foodCache.containsKey(vendorId)) {
      return _foodCache[vendorId]!;
    }

    final foodSnapshot = await FirebaseFirestore.instance
        .collection('vendors')
        .doc(vendorId)
        .collection('foods')
        .get();

    final allFoods = foodSnapshot.docs
        .map((doc) => doc.data())
        .where((data) => data.containsKey('name') && data.containsKey('imageUrl'))
        .toList();

    allFoods.shuffle(Random());
    final selectedFoods = allFoods.take(4).toList();
    _foodCache[vendorId] = selectedFoods;
    return selectedFoods;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.availableCafes),
        backgroundColor: AppTheme.accentGreen,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('vendors').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(AppLocalizations.of(context)!.noVendors),
            );
          }

          final vendors = snapshot.data!.docs;

          return CardSwiper(
            cardsCount: vendors.length,
            numberOfCardsDisplayed: 3,
            isLoop: true, // repeat cards after swipe
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
            cardBuilder: (context, index, percentX, percentY) {
              final vendorDoc = vendors[index];
              final vendor = vendorDoc.data() as Map<String, dynamic>;
              final vendorId = vendorDoc.id;

              return FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchRandomFoods(vendorId),
                builder: (context, foodSnapshot) {
                  final foodItems = foodSnapshot.data ?? [];

                  return Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          child: vendor['logoUrl'] != null &&
                                  vendor['logoUrl'].toString().isNotEmpty
                              ? Image.network(
                                  vendor['logoUrl'],
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.broken_image, size: 100),
                                )
                              : Container(
                                  height: 180,
                                  width: double.infinity,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.store, size: 100),
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                vendor['name'] ??
                                    AppLocalizations.of(context)!.unnamedVendor,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: List.generate(
                                  5,
                                  (index) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      vendor['address'] ?? '',
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.access_time,
                                      size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${vendor['openTime'] ?? 'N/A'} - ${vendor['closeTime'] ?? 'N/A'}',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "Menu",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 6),
                              foodSnapshot.connectionState == ConnectionState.waiting
                                  ? const CircularProgressIndicator()
                                  : foodItems.isEmpty
                                      ? const Text("No menu items.")
                                      : Column(
                                          children: foodItems.map((food) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(vertical: 6),
                                              child: Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(8),
                                                    child: Image.network(
                                                      food['imageUrl'] ?? '',
                                                      height: 40,
                                                      width: 40,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (_, __, ___) =>
                                                          const Icon(Icons.fastfood),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      food['name'] ?? 'Unnamed',
                                                      style: const TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                              const SizedBox(height: 16),
                              Center(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/menu',
                                      arguments: vendor['ownerUid'],
                                    );
                                  },
                                  icon: const Icon(Icons.arrow_forward),
                                  label: const Text("View"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.accentGreen,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
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
}
