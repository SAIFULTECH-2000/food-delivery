import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/features/FoodSwiperScreen.dart';
import 'package:food_delivery_app/features/VendorsScreen.dart';
import 'package:food_delivery_app/features/cart_screen.dart';
import 'package:food_delivery_app/features/favorite_screen.dart';
import 'package:food_delivery_app/features/profile_screen.dart';
import 'package:food_delivery_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'search_result_screen.dart'; // Import the new screen
import 'package:food_delivery_app/l10n/app_localizations.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class ModernHomeScreen extends StatefulWidget {
  const ModernHomeScreen({super.key});

  @override
  State<ModernHomeScreen> createState() => _ModernHomeScreenState();
}

class _ModernHomeScreenState extends State<ModernHomeScreen> {
  int _bottomNavIndex = 0;
  String selectedLocation = 'Library Building';
  String selectedLanguage = 'en';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLanguage = prefs.getString('language') ?? 'en';
      selectedLocation = prefs.getString('location') ?? 'Library Building';
    });
  }

  final userId = FirebaseAuth.instance.currentUser!.uid;

  final localizedOffers = {
    'en': [
      {
        'name': 'Agathiyan Kitchen',
        'logoUrl':
            'https://firebasestorage.googleapis.com/v0/b/food-delivery-4a375.firebasestorage.app/o/vendors%2FWhatsApp%20Image%202025-08-05%20at%209.31.49%20PM.jpeg?alt=media&token=4cf11977-a9d7-4def-b29f-37327d07b1b2',
        'percent': '20% OFF',
        'text': 'Get 20% off on all Tamil Nadu meals above RM40.',
      },
      {
        'name': 'Jaya Catering',
        'logoUrl':
            'https://firebasestorage.googleapis.com/v0/b/food-delivery-4a375.firebasestorage.app/o/vendors%2FWhatsApp%20Image%202025-08-05%20at%209.31.50%20PM.jpeg?alt=media&token=6c9fd1ae-80c4-4a7c-aaf4-4a9c5638ced6',
        'percent': 'Buy 1 Get 1 Free',
        'text': 'BOGO deal on selected South Indian dishes.',
      },
      {
        'name': 'Kopitiam',
        'logoUrl':
            'https://firebasestorage.googleapis.com/v0/b/food-delivery-4a375.firebasestorage.app/o/vendors%2FWhatsApp%20Image%202025-08-05%20at%209.31.49%20PM%20(1).jpeg?alt=media&token=581b1175-c70a-40b1-b801-73c066c50c0f',
        'percent': '15% OFF',
        'text': 'Enjoy traditional Malaysian breakfast with 15% off.',
      },
    ],

    'ms': [
      {
        'name': 'Dapur Agathiyan',
        'logoUrl':
            'https://firebasestorage.googleapis.com/v0/b/food-delivery-4a375.firebasestorage.app/o/vendors%2FWhatsApp%20Image%202025-08-05%20at%209.31.49%20PM.jpeg?alt=media&token=4cf11977-a9d7-4def-b29f-37327d07b1b2',
        'percent': 'Diskaun 20%',
        'text':
            'Dapatkan diskaun 20% untuk semua hidangan Tamil Nadu bernilai lebih RM40.',
      },
      {
        'name': 'Katering Jaya',
        'logoUrl':
            'https://firebasestorage.googleapis.com/v0/b/food-delivery-4a375.firebasestorage.app/o/vendors%2FWhatsApp%20Image%202025-08-05%20at%209.31.50%20PM.jpeg?alt=media&token=6c9fd1ae-80c4-4a7c-aaf4-4a9c5638ced6',
        'percent': 'Beli 1 Percuma 1',
        'text':
            'Promosi beli satu percuma satu untuk hidangan India Selatan terpilih.',
      },
      {
        'name': 'Kopitiam',
        'logoUrl':
            'https://firebasestorage.googleapis.com/v0/b/food-delivery-4a375.firebasestorage.app/o/vendors%2FWhatsApp%20Image%202025-08-05%20at%209.31.49%20PM%20(1).jpeg?alt=media&token=581b1175-c70a-40b1-b801-73c066c50c0f',
        'percent': 'Diskaun 15%',
        'text': 'Nikmati sarapan tradisional Malaysia dengan diskaun 15%.',
      },
    ],
  };

  final Map<String, Map<String, String>> categoryLabels = {
    'en': {
      'Local': 'Local',
      'Breakfast': 'Breakfast',
      'Snacks': 'Snacks',
      'Drinks': 'Drinks',
    },
    'ms': {
      'Local': 'Tempatan',
      'Breakfast': 'Sarapan',
      'Snacks': 'Snek',
      'Drinks': 'Minuman',
    },
  };
  final iconList = <IconData>[
    Icons.home,
    Icons.shopping_cart,
    Icons.favorite,
    Icons.person,
  ];
  void _openSwiper(BuildContext context, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodSwiperScreen(category: category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Theme.of(context).primaryColor,
                      ),
                      DropdownButton2<String>(
                        value: selectedLocation,
                        onChanged: (value) async {
                          if (value != null) {
                            setState(() => selectedLocation = value);
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setString(
                              'selectedLocation',
                              selectedLocation,
                            );
                          }
                        },
                        items:
                            <String>[
                                  'Library Building',
                                  'Medical Building',
                                  'Dental Building',
                                  'Cafeteria Building',
                                  'Anggerik Hostel',
                                  'Bunga Raya Hostel',
                                  'Teratai Hostel',
                                  'Keriang Hostel',
                                  'Jerai Hostel',
                                  'Sports Complex',
                                ]
                                .map(
                                  (item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(item),
                                  ),
                                )
                                .toList(),
                        buttonStyleData: const ButtonStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 2),
                        ),
                        dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                        ),
                        menuItemStyleData: MenuItemStyleData(
                          overlayColor: MaterialStateProperty.all(
                            Colors.red.withOpacity(0.2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 5),
                      DropdownButton<String>(
                        value: selectedLanguage,
                        underline: const SizedBox(),
                        icon: const Icon(Icons.language),
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontWeight: FontWeight.bold,
                        ),
                        dropdownColor: Theme.of(
                          context,
                        ).scaffoldBackgroundColor,
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedLanguage = newValue;
                            });

                            // 🌐 Set locale here
                            Locale locale = newValue == 'en'
                                ? const Locale('en')
                                : const Locale('ms');
                            MyApp.setLocale(context, locale);
                          }
                        },
                        items: <String>['en', 'ms'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value == 'en' ? '🇬🇧 EN' : '🇲🇾 MS'),
                          );
                        }).toList(),
                      ),
                      const SizedBox(width: 10),
                      const ProfileAvatar(),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Search bar with submit
              TextField(
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.craving_question,
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SearchResultScreen(query: value.trim()),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 24),

              // Special Offers
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.specialOffer,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/SpecialOfferSwiperScreen',
                        arguments: selectedLanguage, // or 'en'
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context)!.seeall,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 120,
                child: PageView.builder(
                  controller: PageController(viewportFraction: 0.9),
                  itemCount: (localizedOffers[selectedLanguage] ?? []).length,
                  itemBuilder: (context, index) {
                    final offers = localizedOffers[selectedLanguage] ?? [];
                    final promo = offers[index];

                    final name = promo['name'] ?? 'Unnamed Restaurant';
                    final percent = promo['percent'] ?? '';
                    final text = promo['text'] ?? '';
                    final logoUrl = promo['logoUrl'] ?? '';

                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              contentPadding: const EdgeInsets.all(16),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (logoUrl.isNotEmpty)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        logoUrl,
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  const SizedBox(height: 12),
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    percent,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    text,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Close'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.secondary.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      percent,
                                      style: const TextStyle(
                                        fontSize: 32,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      text,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Categories
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  CategoryItem(
                    icon: Icons.restaurant,
                    label: categoryLabels[selectedLanguage]!['Local']!,
                    onTap: () => _openSwiper(context, 'Local'),
                  ),

                  CategoryItem(
                    icon: Icons.free_breakfast,
                    label: categoryLabels[selectedLanguage]!['Breakfast']!,
                    onTap: () => _openSwiper(context, 'Breakfast'),
                  ),

                  CategoryItem(
                    icon: Icons.fastfood,
                    label: categoryLabels[selectedLanguage]!['Snacks']!,
                    onTap: () => _openSwiper(context, 'Snacks'),
                  ),

                  CategoryItem(
                    icon: Icons.local_drink,
                    label: categoryLabels[selectedLanguage]!['Drinks']!,
                    onTap: () => _openSwiper(context, 'Drinks'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              //  Discount Guaranteed
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.discountGuaranteed,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.antiAlias,
                child: PageView(
                  children: [
                    Container(
                      color: Colors.yellow, // background color
                      child: Image.asset(
                        'assets/promo.png',
                        fit: BoxFit.fill, // prevent resizing
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // FAB
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const VendorsScreen()),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(Icons.shopping_bag),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTabIcon(Icons.home, 0),
              CartIconWithBadge(
                userId: userId,
                isActive: _bottomNavIndex == 1,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                  setState(() => _bottomNavIndex = 0);
                },
              ),
              const SizedBox(width: 48), // space for FAB
              _buildTabIcon(Icons.favorite, 2),
              _buildTabIcon(Icons.person, 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabIcon(IconData icon, int index) {
    return IconButton(
      icon: Icon(
        icon,
        color: _bottomNavIndex == index
            ? Theme.of(context).colorScheme.secondary
            : Colors.grey,
      ),
      onPressed: () {
        setState(() => _bottomNavIndex = index);

        // Navigate for Favorite and Profile screens
        if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FavoriteScreen()),
          );
        } else if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        }
      },
    );
  }
}

class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const CategoryItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Theme.of(
              context,
            ).colorScheme.secondary.withOpacity(0.1),
            child: Icon(icon, color: Theme.of(context).colorScheme.secondary),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  Future<String?> getProfileImageUrl() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    return doc.data()?['profileImageUrl'] as String?;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/profile'); // Adjust the route if needed
      },
      child: FutureBuilder<String?>(
        future: getProfileImageUrl(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
            );
          }
          final imageUrl = snapshot.data;
          return CircleAvatar(
            radius: 16,
            backgroundImage: imageUrl != null && imageUrl.isNotEmpty
                ? NetworkImage(imageUrl)
                : const AssetImage('assets/images/default_avatar.png')
                      as ImageProvider,
          );
        },
      ),
    );
  }
}

class CartIconWithBadge extends StatelessWidget {
  final String userId;
  final VoidCallback onTap;
  final bool isActive;

  const CartIconWithBadge({
    super.key,
    required this.userId,
    required this.onTap,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart')
          .snapshots(),
      builder: (context, snapshot) {
        final count = snapshot.data?.docs.length ?? 0;

        return InkWell(
          onTap: onTap,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.shopping_cart,
                color: isActive
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.grey,
              ),
              if (count > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$count',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
