import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:food_delivery_app/core/theme/app_theme.dart';
import 'package:food_delivery_app/features/favorite_screen.dart';
import 'package:food_delivery_app/l10n/app_localizations.dart';
import 'dart:math';

class VendorsScreen extends StatefulWidget {
  const VendorsScreen({super.key});

  @override
  State<VendorsScreen> createState() => _VendorsScreenState();
}

class _VendorsScreenState extends State<VendorsScreen> {
  final Map<String, List<Map<String, dynamic>>> _foodCache = {};
  final int _bottomNavIndex = 0;

  final List<IconData> _navIcons = [
    Icons.home,
    Icons.shopping_cart,
    Icons.favorite,
    Icons.person,
  ];

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
        .where(
          (data) => data.containsKey('name') && data.containsKey('imageUrl'),
        )
        .toList();

    allFoods.shuffle(Random());
    final selectedFoods = allFoods.take(5).toList();
    _foodCache[vendorId] = selectedFoods;
    return selectedFoods;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Hides back button
        backgroundColor: Colors.transparent, // Transparent background
        elevation: 0, // No shadow
      ),
      // FAB
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle FAB press
        },
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(Icons.shopping_bag),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Bottom Navigation Bar
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: _navIcons,
        activeIndex: -1, // No icon is active
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        backgroundColor: Theme.of(context).cardColor, // Use theme's card color
        activeColor: Theme.of(context).colorScheme.secondary, // Use accentGreen
        inactiveColor: Theme.of(context).colorScheme.onSurface.withOpacity(
          0.6,
        ), // Use theme's onSurface with opacity
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/dashboard');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/cart');
          } else if (index == 3) {
            Navigator.pushNamed(context, '/profile');
          }
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavoriteScreen()),
            );
          }
        },
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('vendors').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text(AppLocalizations.of(context)!.noVendors));
          }

          final vendors = snapshot.data!.docs;

          return Column(
            children: [
              Expanded(
                child: CardSwiper(
                  cardsCount: vendors.length,
                  numberOfCardsDisplayed: 3,
                  isLoop: true,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 32,
                  ),
                  cardBuilder: (context, index, percentX, percentY) {
                    final vendorDoc = vendors[index];
                    final vendor = vendorDoc.data() as Map<String, dynamic>;
                    final vendorId = vendorDoc.id;

                    return FutureBuilder<List<Map<String, dynamic>>>(
                      future: fetchRandomFoods(vendorId),
                      builder: (context, foodSnapshot) {
                        final foodItems = foodSnapshot.data ?? [];

                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Theme.of(context).cardColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Image.network(
                                      vendor['logoUrl'] ?? '',
                                      height: 180,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        height: 180,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        height: 60,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black.withOpacity(0.6),
                                            ],
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        child: Text(
                                          vendor['name'] ?? 'Vendor',
                                          style: TextStyle(
                                            color: AppTheme.accentGreen,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withOpacity(0.6),
                                            size: 18,
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              vendor['address'] ?? '',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withOpacity(0.7),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withOpacity(0.6),
                                            size: 18,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${vendor['openTime'] ?? 'N/A'} - ${vendor['closeTime'] ?? 'N/A'}',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withOpacity(0.7),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        "Menu Preview",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      SizedBox(
                                        height: 60,
                                        child:
                                            foodSnapshot.connectionState ==
                                                ConnectionState.waiting
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : foodItems.isEmpty
                                            ? const Center(
                                                child: Text("No items"),
                                              )
                                            : ListView.separated(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: foodItems.length,
                                                itemBuilder: (context, idx) {
                                                  final food = foodItems[idx];
                                                  return Column(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                        child: Image.network(
                                                          food['imageUrl'] ??
                                                              '',
                                                          height: 40,
                                                          width: 40,
                                                          fit: BoxFit.cover,
                                                          errorBuilder:
                                                              (
                                                                _,
                                                                __,
                                                                ___,
                                                              ) => const Icon(
                                                                Icons.fastfood,
                                                              ),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 2),
                                                      Text(
                                                        food['name'] ?? '',
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onSurface,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  );
                                                },
                                                separatorBuilder: (_, __) =>
                                                    const SizedBox(width: 8),
                                              ),
                                      ),
                                      const SizedBox(height: 16),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              '/menu',
                                              arguments: vendor['ownerUid'],
                                            );
                                          },
                                          icon: const Icon(Icons.arrow_forward),
                                          label: const Text("View Menu"),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppTheme.accentGreen,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.copyrightAimstUniversity,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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
}
