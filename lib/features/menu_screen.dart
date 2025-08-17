import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/theme/app_theme.dart';
import 'package:food_delivery_app/features/FoodDetailScreen.dart';
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
  List<Map<String, dynamic>> filteredItems = [];
  List<String> availableCategories = [];

  double? minPrice;
  double? maxPrice;
  bool? isVegFilter; // null = all, true = veg, false = non-veg

  int _selectedIndex = 1;
  int cartCount = 0;
  late String vendorId;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      vendorId = ModalRoute.of(context)!.settings.arguments as String;

      // Fetch categories
      final cats = await fetchAvailableCategories(vendorId);
      setState(() {
        availableCategories = cats;
        selectedCategory = cats.isNotEmpty ? cats.first : 'All';
      });

      // Load foods for first category
      final items = await fetchFoodItemsByCategory(vendorId, selectedCategory);
      setState(() {
        allFoods = items;
        filteredItems = List.from(allFoods);
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

  Future<List<String>> fetchAvailableCategories(String vendorId) async {
    final vendorDoc = await FirebaseFirestore.instance
        .collection('vendors')
        .doc(vendorId)
        .collection('foods')
        .get();

    final categoriesSet = <String>{};
    for (var doc in vendorDoc.docs) {
      final category = doc.data()['category'];
      if (category != null && category.toString().isNotEmpty) {
        categoriesSet.add(category.toString());
      }
    }
    return ['All', ...categoriesSet.toList()];
  }

  Future<List<Map<String, dynamic>>> fetchFoodItemsByCategory(
    String vendorId,
    String category,
  ) async {
    final vendorDoc = await FirebaseFirestore.instance
        .collection('vendors')
        .doc(vendorId)
        .get();

    final restaurantName = vendorDoc.data()?['name'] ?? 'Unknown Vendor';

    Query query = FirebaseFirestore.instance
        .collection('vendors')
        .doc(vendorId)
        .collection('foods');

    if (category != 'All') {
      query = query.where('category', isEqualTo: category);
    }

    final snapshot = await query.get();

    final foods = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'name': data['name'],
        'desc': data['description'],
        'price': data['price'],
        'imageUrl': data['imageUrl'],
        'category': data['category'],
        'kcal': data['kcal'],
        'restaurantName': restaurantName,
        'isTopMenu': data['isTopMenu'],
        'minToServe': data['minToServe'],
        'ingredients': data['ingredients'],
        'isVeg': data['isVeg'], // ✅ make sure foods collection has this field
      };
    }).toList();

    return foods;
  }

  void _applyFilters() {
    setState(() {
      filteredItems = allFoods.where((item) {
        final price = item['price'] is int
            ? (item['price'] as int).toDouble()
            : (item['price'] as double);

        final matchesSearch =
            item['name']?.toString().toLowerCase().contains(
              searchController.text.toLowerCase(),
            ) ??
            false;

        final matchesMin = minPrice == null || price >= minPrice!;
        final matchesMax = maxPrice == null || price <= maxPrice!;
        final matchesVeg = isVegFilter == null || item['isVeg'] == isVegFilter;

        return matchesSearch && matchesMin && matchesMax && matchesVeg;
      }).toList();
    });
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
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          loc.browseFoods,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
      body: Column(
        children: [
          // Search + Filter
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: loc.search,
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) => _applyFilters(),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.filter_alt),
                onPressed: () {
                  _showFilterDialog(context, (min, max, veg) {
                    minPrice = min;
                    maxPrice = max;
                    isVegFilter = veg;
                    _applyFilters();
                  });
                },
              ),
            ],
          ),

          // Categories
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: availableCategories.length,
              itemBuilder: (context, index) {
                final category = availableCategories[index];
                final isSelected = selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    selectedColor: AppTheme.accentGreen,
                    onSelected: (_) async {
                      setState(() {
                        selectedCategory = category;
                      });
                      final items = await fetchFoodItemsByCategory(
                        vendorId,
                        category,
                      );
                      setState(() {
                        allFoods = items;
                        _applyFilters();
                      });
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),

          // Food Grid
          Expanded(
            child: filteredItems.isEmpty
                ? Center(child: Text(loc.noFoodsFound))
                : GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    children: filteredItems.map((item) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FoodDetailScreen(foodItem: item),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                    child: Image.network(
                                      item['imageUrl'] ?? '',
                                      height: 100,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          const Icon(Icons.image, size: 100),
                                    ),
                                  ),
                                  if (item['isTopMenu'] == true)
                                    Positioned(
                                      top: 8,
                                      left: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.redAccent,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: const Text(
                                          '🔥 Best Seller 👍',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'] ?? '',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${item['minToServe']} Min   ${item['kcal']} kcal',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),

      // Chat Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.accentRed,
        onPressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(loc.openingChatSupport)));
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.pushNamed(context, '/chat');
          });
        },
        child: const Icon(Icons.smart_toy, color: Colors.white),
      ),
    );
  }
}

void _showFilterDialog(
  BuildContext context,
  Function(double?, double?, bool?) onApply,
) {
  final minController = TextEditingController();
  final maxController = TextEditingController();
  bool? tempIsVegFilter;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: const [
                Icon(Icons.filter_alt, color: Colors.green),
                SizedBox(width: 8),
                Text("Filters"),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Price Min
                  TextField(
                    controller: minController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: "Minimum Price",
                      prefixText: "RM ",
                      border: UnderlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Price Max
                  TextField(
                    controller: maxController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: "Maximum Price",
                      prefixText: "RM ",
                      border: UnderlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Veg / Non-Veg filter
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Food Type",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    children: [
                      ChoiceChip(
                        label: const Text("All"),
                        selected: tempIsVegFilter == null,
                        onSelected: (_) =>
                            setState(() => tempIsVegFilter = null),
                      ),
                      ChoiceChip(
                        label: const Text("Veg"),
                        selected: tempIsVegFilter == true,
                        onSelected: (_) =>
                            setState(() => tempIsVegFilter = true),
                      ),
                      ChoiceChip(
                        label: const Text("Non-Veg"),
                        selected: tempIsVegFilter == false,
                        onSelected: (_) =>
                            setState(() => tempIsVegFilter = false),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  final min = double.tryParse(minController.text);
                  final max = double.tryParse(maxController.text);
                  onApply(min, max, tempIsVegFilter);
                  Navigator.pop(context);
                },
                child: const Text("Apply"),
              ),
            ],
          );
        },
      );
    },
  );
}
