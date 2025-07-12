import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery_app/core/theme/app_theme.dart';

class BrowseFoodScreen extends StatefulWidget {
  const BrowseFoodScreen({super.key});

  @override
  State<BrowseFoodScreen> createState() => _BrowseFoodScreenState();
}

class _BrowseFoodScreenState extends State<BrowseFoodScreen> {
  String selectedCategory = 'All';
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> allFoods = [];

  Future<List<Map<String, dynamic>>> fetchFoodItems() async {
    List<Map<String, dynamic>> foodList = [];

    try {
      final vendorSnapshot = await FirebaseFirestore.instance.collection('vendors').get();

      for (var vendorDoc in vendorSnapshot.docs) {
        final foodsSnapshot = await vendorDoc.reference.collection('foods').get();

        for (var foodDoc in foodsSnapshot.docs) {
          final data = foodDoc.data();
          foodList.add({
            'name': data['name'],
            'desc': data['desc'],
            'price': data['price'],
            'imageUrl': data['imageUrl'],
            'category': data['category'],
          });
        }
      }
    } catch (e) {
      print("🔥 Error loading foods: $e");
    }

    allFoods = foodList;
    return foodList;
  }

  List<Map<String, dynamic>> filterItems() {
    return allFoods.where((item) {
      final matchesCategory =
          selectedCategory == 'All' || item['category'] == selectedCategory;
      final matchesSearch = item['name']
              ?.toString()
              .toLowerCase()
              .contains(searchController.text.toLowerCase()) ??
          false;
      return matchesCategory && matchesSearch;
    }).toList();
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
            Navigator.pushNamed(context, '/dashboard');
          },
        ),
        title: const Text(
          'Browse Food',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: FutureBuilder(
        future: fetchFoodItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text("Error loading menu"));
          }

          final filteredItems = filterItems();

          return Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for meals or stalls',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) => setState(() {}),
                ),
              ),

              // Category Chips
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: ['All', 'Rice', 'Noodles', 'Drinks', 'Snacks', 'Western', 'Indian']
                      .map((category) {
                    final isSelected = selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        selectedColor: AppTheme.accentGreen,
                        onSelected: (_) {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 10),

              // Food List
              Expanded(
                child: filteredItems.isEmpty
                    ? const Center(child: Text('No food found'))
                    : ListView.builder(
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: const BorderSide(color: Colors.black12),
                              ),
                              child: Row(
                                children: [
                                  // Image
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                    ),
                                    child: Image.network(
                                      item['imageUrl'] ?? '',
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => const Icon(Icons.image),
                                    ),
                                  ),
                                  const SizedBox(width: 10),

                                  // Info
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 4),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['name'] ?? '',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            item['desc'] ?? '',
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            'RM${_formatPrice(item['price'])}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.green,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          ElevatedButton(
                                            onPressed: () {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('${item['name']} added to cart'),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppTheme.accentGreen,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                            ),
                                            child: const Text(
                                              'Add to Cart',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatPrice(dynamic price) {
    if (price is double) return price.toStringAsFixed(2);
    if (price is int) return price.toStringAsFixed(2);
    if (price is String) return price;
    return '0.00';
  }
}
