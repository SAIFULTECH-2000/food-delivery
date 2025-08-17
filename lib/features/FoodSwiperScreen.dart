import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toastification/toastification.dart';

class FoodSwiperScreen extends StatefulWidget {
  final String category;
  const FoodSwiperScreen({super.key, required this.category});

  @override
  State<FoodSwiperScreen> createState() => _FoodSwiperScreenState();
}

class _FoodSwiperScreenState extends State<FoodSwiperScreen> {
  List<Map<String, dynamic>> foodItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFoodItems();
  }

  Future<void> loadFoodItems() async {
    setState(() => isLoading = true);

    try {
      // Step 1: Get all vendor IDs
      final vendorsSnapshot = await FirebaseFirestore.instance
          .collection('vendors')
          .get();
      final vendorIds = vendorsSnapshot.docs.map((doc) => doc.id).toList();

      // Step 2: Fetch foods from each vendor
      List<Map<String, dynamic>> allFoods = [];

      for (var vendorId in vendorIds) {
        final foodsSnapshot = await FirebaseFirestore.instance
            .collection('vendors')
            .doc(vendorId)
            .collection('foods')
            .where('category', isEqualTo: widget.category) // exact match
            .get();

        allFoods.addAll(
          foodsSnapshot.docs.map(
            (doc) => {...doc.data(), 'id': doc.id, 'vendorId': vendorId},
          ),
        );
      }

      setState(() {
        foodItems = allFoods;
        isLoading = false;
      });

      // Step 3: Update state
      setState(() {
        foodItems = allFoods;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading foods: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (foodItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.category)),
        body: const Center(child: Text('No items found.')),
      );
    }

    return Scaffold(
      body: PageView.builder(
        itemCount: foodItems.length,
        itemBuilder: (context, index) {
          return FoodDetailCard(foodItem: foodItems[index]);
        },
      ),
    );
  }
}

class FoodDetailCard extends StatefulWidget {
  final Map<String, dynamic> foodItem;
  const FoodDetailCard({super.key, required this.foodItem});

  @override
  State<FoodDetailCard> createState() => _FoodDetailCardState();
}

class _FoodDetailCardState extends State<FoodDetailCard> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final item = widget.foodItem;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        // Top section with image and icons
        Stack(
          children: [
            Container(
              height: 280,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: theme.canvasColor,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Icon(Icons.favorite_border, color: theme.canvasColor),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      item['imageUrl'] ?? '',
                      height: 160,
                      width: 160,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.image, size: 100),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Title and Info
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                item['name'] ?? 'Unknown Food',
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.timer,
                    size: 16,
                    color: theme.colorScheme.secondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "${item['minToServe']} min",
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.star, size: 16, color: Colors.orange),
                  const SizedBox(width: 4),
                  Text("4.8", style: theme.textTheme.bodySmall),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.local_fire_department,
                    size: 16,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "${item['kcal']} Kcal",
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),

        // Price and Quantity
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("RM", style: theme.textTheme.titleMedium),
              Text(
                "${item['price']}",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 20),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (quantity > 1) {
                          setState(() => quantity--);
                        }
                      },
                    ),
                    Text(quantity.toString(), style: theme.textTheme.bodyLarge),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() => quantity++);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Ingredients
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text("Ingredients", style: theme.textTheme.titleMedium),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: const [
              _IngredientChip(name: "Noodle", icon: Icons.ramen_dining),
              _IngredientChip(name: "Shrimp", icon: Icons.set_meal),
              _IngredientChip(name: "Egg", icon: Icons.egg_alt),
              _IngredientChip(name: "Scallion", icon: Icons.grass),
            ],
          ),
        ),

        // About
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text("About", style: theme.textTheme.titleMedium),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            item['desc'] ?? 'No description available.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
          ),
        ),

        const Spacer(),

        // Add to Cart
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: () async {
              final uid = FirebaseAuth.instance.currentUser?.uid;
              if (uid == null) return;

              final cartItem = {
                'name': item['name'],
                'price': item['price'],
                'imageUrl': item['imageUrl'],
                'restaurantName':
                    item['restaurantName'] ?? 'Unknown Restaurant',
                'quantity': quantity,
                'createdAt': FieldValue.serverTimestamp(),
              };

              final cartRef = FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .collection('cart')
                  .doc(item['id']); // Ensure 'id' exists in foodItem

              final existingItem = await cartRef.get();

              if (existingItem.exists) {
                final currentQty = existingItem.data()?['quantity'] ?? 1;
                await cartRef.update({'quantity': currentQty + quantity});
              } else {
                await cartRef.set(cartItem);
              }

              toastification.show(
                context: context,
                title: const Text('Item added to cart'),
                description: const Text(
                  'Meal added! Don’t forget to check out your cart.',
                ),
                autoCloseDuration: const Duration(seconds: 3),
                type: ToastificationType.success,
                alignment: Alignment.bottomCenter,
              );
            },
            icon: const Icon(Icons.shopping_cart),
            label: Text(
              "Add to cart",
              style: TextStyle(color: Theme.of(context).canvasColor),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Theme.of(context).colorScheme.secondary,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _IngredientChip extends StatelessWidget {
  final String name;
  final IconData icon;

  const _IngredientChip({required this.name, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: 6),
          Text(name, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
