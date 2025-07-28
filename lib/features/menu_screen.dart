import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/theme/app_theme.dart';
import 'package:food_delivery_app/l10n/app_localizations.dart';

class BrowseFoodScreen extends StatefulWidget {
  const BrowseFoodScreen({super.key});

  @override
  State<BrowseFoodScreen> createState() => _BrowseFoodScreenState();
}

class _BrowseFoodScreenState extends State<BrowseFoodScreen> {
  String selectedCategory = 'All';
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> allFoods = [];

  int _selectedIndex = 1;
  int cartCount = 0;
  late String vendorId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      vendorId = ModalRoute.of(context)!.settings.arguments as String;
      fetchFoodItems(vendorId).then((items) {
        setState(() {
          allFoods = items;
        });
      });
    });
    fetchCartCount();
  }

  Future<void> fetchCartCount() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final cartSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('cart')
        .get();

    setState(() {
      cartCount = cartSnapshot.docs.length;
    });
  }

  Future<List<Map<String, dynamic>>> fetchFoodItems(String vendorId) async {
    List<Map<String, dynamic>> foodList = [];

    try {
      final vendorDoc = await FirebaseFirestore.instance
          .collection('vendors')
          .doc(vendorId)
          .get();

      if (!vendorDoc.exists) return foodList;

      final foodsSnapshot = await vendorDoc.reference.collection('foods').get();
      final vendorData = vendorDoc.data();
      final vendorName = vendorData?['name'] ?? 'Unknown';

      for (var foodDoc in foodsSnapshot.docs) {
        final data = foodDoc.data();
        foodList.add({
          'name': data['name'],
          'desc': data['desc'],
          'price': data['price'],
          'imageUrl': data['imageUrl'],
          'category': data['category'],
          'restaurantName': vendorName,
        });
      }
    } catch (e) {
      print("🔥 Error loading foods: $e");
    }

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

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/dashboard');
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/cart');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/notifications');
        break;
    }
  }
   @override
  Widget build(BuildContext context) {
    final filteredItems = filterItems();
final loc = AppLocalizations.of(context)!;

final categories = [
  {'key': 'all', 'value': loc.all},
  {'key': 'rice', 'value': loc.rice},
  {'key': 'noodles', 'value': loc.noodles},
  {'key': 'drinks', 'value': loc.beverages},
  {'key': 'snacks', 'value': loc.snacks},
  {'key': 'western', 'value': loc.western},
  {'key': 'indian', 'value': loc.indian},
];
    return Scaffold(
      backgroundColor: AppTheme.canvasCream,
      appBar: AppBar(
        backgroundColor: AppTheme.canvasCream,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Browse Food',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
         Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  child: TextField(
    controller: searchController,
    decoration: InputDecoration(
      hintText: AppLocalizations.of(context)!.search,
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
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
             children: categories.map((category) {
      final isSelected = selectedCategory == category['key'];
      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: ChoiceChip(
          label: Text(category['value']!),
          selected: isSelected,
          selectedColor: AppTheme.accentGreen,
          onSelected: (_) {
            setState(() {
              selectedCategory = category['key']!;
            });
          },
        ),
      );
    }).toList(),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
 child: filteredItems.isEmpty
    ? Center(child: Text(AppLocalizations.of(context)!.noFoodsFound))

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
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
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
                                        onPressed: () async {
                                          final uid =
                                              FirebaseAuth.instance.currentUser!.uid;
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(uid)
                                              .collection('cart')
                                              .add({
                                            'name': item['name'],
                                            'price': item['price'],
                                            'imageUrl': item['imageUrl'],
                                            'restaurantName': item['restaurantName'],
                                            'quantity': 1,
                                            'createdAt': FieldValue.serverTimestamp(),
                                          });

                                          fetchCartCount();

                                   ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(
      AppLocalizations.of(context)!.addedToCart(item['name']),
    ),
  ),
);

                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppTheme.accentGreen,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                      child: Text(
  AppLocalizations.of(context)!.addToCart,
  style: const TextStyle(color: Colors.white),
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
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.accentGreen,
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(AppLocalizations.of(context)!.openingChatSupport),
  ),
);
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.pushNamed(context, '/chat');
          });
        },
        child: const Icon(Icons.chat, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        items: [
       BottomNavigationBarItem(
  icon: const Icon(Icons.home),
  label: AppLocalizations.of(context)!.dashboard,
),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                if (cartCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$cartCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label:  AppLocalizations.of(context)!.cart,
          ),
        BottomNavigationBarItem(
  icon: const Icon(Icons.shopping_bag),
  label: AppLocalizations.of(context)!.orders,
),
        ],
      ),
    );
  }

  String _formatPrice(dynamic price) {
    if (price is double) return price.toStringAsFixed(2);
    if (price is int) return price.toDouble().toStringAsFixed(2);
    if (price is String) return price;
    return '0.00';
  }
}