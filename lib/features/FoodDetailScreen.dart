import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/theme/app_theme.dart';
import 'package:toastification/toastification.dart';

class FoodDetailScreen extends StatefulWidget {
  final Map<String, dynamic> foodItem;

  const FoodDetailScreen({super.key, required this.foodItem});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  int quantity = 1;
  bool isFavorite = false; // ✅ move outside build

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  // ✅ async function to load favorite from Firebase
  Future<void> _loadFavoriteStatus() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final itemId = widget.foodItem['id']; // unique ID for the food
    final favDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(itemId)
        .get();

    setState(() {
      isFavorite = favDoc.exists;
    });
  }

  // ✅ map Firestore ingredient icon string to Flutter IconData
  IconData _mapIcon(String? iconName) {
    switch ((iconName ?? '').toLowerCase()) {
      case 'egg_alt':
        return Icons.egg_alt;
      case 'ramen_dining':
        return Icons.ramen_dining;
      case 'set_meal':
        return Icons.set_meal;
      case 'grass':
        return Icons.grass;
      case 'rice_bowl':
        return Icons.rice_bowl;
      case 'emoji_food_beverage':
        return Icons.emoji_food_beverage;
      case 'lunch_dining':
        return Icons.lunch_dining;
      case 'restaurant':
        return Icons.restaurant;
      case 'restaurant_menu':
        return Icons.restaurant_menu;
      case 'local_drink':
        return Icons.local_drink;
      case 'kebab_dining':
        return Icons.kebab_dining;
      case 'bakery_dining':
        return Icons.bakery_dining;
      case 'icecream':
        return Icons.icecream;
      default:
        return Icons.fastfood; // fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.foodItem;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
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
                                Navigator.pop(
                                  context,
                                ); // Go back to previous screen
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.red,
                              ),
                              onPressed: () async {
                                final uid =
                                    FirebaseAuth.instance.currentUser?.uid;
                                if (uid == null) return;

                                final favRef = FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(uid)
                                    .collection('favorites')
                                    .doc(
                                      item['id'],
                                    ); // ensure each food item has an id

                                if (isFavorite) {
                                  // remove from favorites
                                  await favRef.delete();
                                  setState(() => isFavorite = false);

                                  _showCutePopup(
                                    context,
                                    title: "Removed 💔",
                                    message:
                                        "${item['name']} has been removed from your favorites.",
                                    color: Colors.redAccent,
                                  );
                                } else {
                                  // add to favorites
                                  await favRef.set({
                                    'name': item['name'],
                                    'price': item['price'],
                                    'imageUrl': item['imageUrl'],
                                    'category': item['category'],
                                    'addedAt': FieldValue.serverTimestamp(),
                                  });
                                  setState(() => isFavorite = true);

                                  _showCutePopup(
                                    context,
                                    title: "Added 💖",
                                    message:
                                        "${item['name']} is now in your favorites!",
                                    color: Colors.pinkAccent,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Stack(
                        alignment: Alignment.center,
                        children: [
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
                          if (item['isTopMenu'] ==
                              true) // show banner if best seller
                            Positioned(
                              bottom: 8, // position at bottom
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'Best Seller',
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
                    "${(item['price'] as num).toStringAsFixed(2)}",
                    style: theme.textTheme.titleMedium?.copyWith(
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
                        Text(
                          quantity.toString(),
                          style: theme.textTheme.bodyLarge,
                        ),
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
            if (item['ingredients'] != null && item['ingredients'] is List)
              SizedBox(
                height: 80,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  children: (item['ingredients'] as List).map((ing) {
                    final name = ing['name'] ?? '';
                    final iconName = ing['icon'] ?? '';
                    return _IngredientChip(
                      name: name,
                      icon: _mapIcon(iconName),
                    );
                  }).toList(),
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

                  final item = widget.foodItem;
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
                      .doc(item['id']); // Ensure 'id' exists in your foodItem

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
        ),
      ),
    );
  }

  void _showCutePopup(
    BuildContext context, {
    required String title,
    required String message,
    required Color color,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: color.withOpacity(0.2),
                  child: Icon(Icons.favorite, color: color, size: 35),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Okay"),
                ),
              ],
            ),
          ),
        );
      },
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
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
            child: Icon(icon, color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 4),
          Text(name, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
