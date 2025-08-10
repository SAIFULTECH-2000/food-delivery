import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> uploadVendorsAndMenus() async {
  final vendors = [
    {
      'vendorId': 'kopitiam-uid',
      'data': {
        'name': 'Kopitiam',
        'email': 'kopitiam@example.com',
        'phone': '0123456781',
        'address': 'Student Centre, AIMST',
        'logoUrl':
            'https://www.businesstoday.com.my/wp-content/uploads/2025/01/oriental-kopi-outlet.jpg',
        'ownerUid': 'kopitiam-uid',
        'openDays': ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
        'openTime': '07:30',
        'closeTime': '16:00',
        'createdAt': FieldValue.serverTimestamp(),
      },
      'foods': [
        {
          "name": "Nasi Lemak",
          "description":
              "A classic Malaysian dish featuring fragrant coconut rice, spicy sambal, crispy anchovies, roasted peanuts, a hard-boiled egg, and refreshing cucumber slices. A harmonious blend of flavors and textures.",
          "price": 5.0,
          "imageUrl":
              "https://www.andy-cooks.com/cdn/shop/articles/20231116072724-c2-a9andy_cooks_thumbnails_nasi_lemak_01.jpg?v=1700389619",
          "category": "Local",
          "mainIngredients": [
            {"name": "Egg", "icon": "egg_alt"},
            {"name": "Scallion", "icon": "grass"},
          ],
          "relatedIngredients": [],
          "kcal": 421,
          "minToServe": 9,
          "isTopMenu": true,
        },
        {
          "name": "Roti Bakar",
          "description":
              "A popular Malaysian breakfast, Roti Bakar features perfectly grilled bread slices, generously spread with sweet kaya (coconut jam) and a slab of cold butter, offering a delightful contrast of textures and flavors.",
          "price": 3.0,
          "imageUrl":
              "https://wiratech.co.id/wp-content/uploads/2018/03/peluang-bisnis-roti-bakar-dan-analisa-usahanya-pengusaha-sukses.jpg",
          "category": "Breakfast",
          "mainIngredients": [
            {"name": "Egg", "icon": "egg_alt"},
          ],
          "relatedIngredients": [],
          "kcal": 365,
          "minToServe": 5,
          "isTopMenu": Random().nextBool(),
        },
        {
          "name": "Half Boiled Eggs",
          "description": "2 soft boiled eggs with soy sauce and pepper",
          "price": 2.5,
          "imageUrl":
              "https://www.ajinomotofoodbizpartner.com.my/wp-content/uploads/2023/09/Half-boiled-Egg-thumbnail-03.jpg",
          "category": "Breakfast",
          "ingredients": [
            {"name": "Egg", "icon": "egg_alt"},
          ],
          "kcal": 209,
          "minToServe": 6,
        },
        {
          "name": "Mee Hoon Goreng",
          "description": "Stir-fried vermicelli noodles",
          "price": 4.5,
          "imageUrl":
              "https://www.maggi.my/sites/default/files/srh_recipes/0a0a73c86c37d751860d480cdcffbc9c.jpg",
          "category": "Local",
          "ingredients": [
            {"name": "Noodle", "icon": "ramen_dining"},
            {"name": "Scallion", "icon": "grass"},
          ],
          "kcal": 509,
          "minToServe": 10,
        },
        {
          "name": "Kaya Puff",
          "description": "Crispy pastry with kaya filling",
          "price": 2.0,
          "imageUrl":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTGLKmEMtcnMs9Fflgrd2kWhrOpMgAeVLqQwA&s",
          "category": "Snacks",
          "ingredients": [],
          "kcal": 287,
          "minToServe": 3,
        },
        {
          "name": "Curry Puff",
          "description": "Pastry with curried potato filling",
          "price": 2.0,
          "imageUrl":
              "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Karipap_Daging.jpg/960px-Karipap_Daging.jpg",
          "category": "Snacks",
          "ingredients": [
            {"name": "Egg", "icon": "egg_alt"},
          ],
          "kcal": 223,
          "minToServe": 3,
        },
        {
          "name": "Fried Spring Roll",
          "description": "Vegetable-filled fried rolls",
          "price": 2.5,
          "imageUrl":
              "https://thai-foodie.com/wp-content/uploads/2023/07/thai-egg-rolls-redo.jpg",
          "category": "Snacks",
          "ingredients": [
            {"name": "Scallion", "icon": "grass"},
          ],
          "kcal": 181,
          "minToServe": 2,
        },
        {
          "name": "Teh Tarik",
          "description": "Classic pulled milk tea",
          "price": 2.0,
          "imageUrl":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQbPLBRQf7HXIop-YgG_oAqWee12BExUqB-5w&s",
          "category": "Drinks",
          "ingredients": [],
          "kcal": 104,
          "minToServe": 4,
        },
        {
          "name": "Kopi O",
          "description": "Black coffee",
          "price": 1.8,
          "imageUrl":
              "https://munchmalaysia.com/wp-content/uploads/2024/01/Kopi-O-1024x709.jpg",
          "category": "Drinks",
          "ingredients": [],
          "kcal": 139,
          "minToServe": 3,
        },
        {
          "name": "Milo Ais",
          "description": "Iced chocolate malt drink",
          "price": 2.5,
          "imageUrl":
              "https://munchmalaysia.com/wp-content/uploads/2023/11/milo-ais-683x1024.jpg",
          "category": "Drinks",
          "ingredients": [],
          "kcal": 93,
          "minToServe": 3,
        },
      ],
    },
    // Add other vendors the same way:
    {
      'vendorId': 'jaya-uid',
      'data': {
        'name': 'Jaya Catering',
        'email': 'jaya@example.com',
        'phone': '0123456782',
        'address': 'Cafeteria Block A, AIMST',
        'logoUrl':
            'https://i0.wp.com/runningmen.my/wp-content/uploads/2023/12/DSC_3991.jpg?fit=4512%2C3008&ssl=1',
        'ownerUid': 'jaya-uid',
        'openDays': [
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday',
        ],
        'openTime': '08:00',
        'closeTime': '19:00',
        'createdAt': FieldValue.serverTimestamp(),
      },
      'foods': [
        {
          'name': 'Chicken Rice',
          'description':
              'Tender steamed or roasted chicken served with fragrant rice, chili sauce, and soy sauce.',
          'price': 6.50,
          'imageUrl':
              'https://nomadette.com/wp-content/uploads/2025/01/Honey-Roasted-Chicken-Rice.jpg',
          'category': 'Rice',
          'mainIngredients': [
            {'name': 'Chicken', 'icon': 'set_meal'},
            {'name': 'Rice', 'icon': 'rice_bowl'},
            {'name': 'Chili', 'icon': 'local_fire_department'},
          ],
          'kcal': 520,
          'minToServe': 8,
          'isTopMenu': true,
        },
        {
          'name': 'Nasi Campur',
          'description':
              'Steamed rice served with a variety of side dishes of your choice.',
          'price': 7.00,
          'imageUrl':
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxeob0RTrSBBVQh1aBrk-p4Vrnne_dH2Tqqw&s',
          'category': 'Rice',
          'mainIngredients': [
            {'name': 'Rice', 'icon': 'rice_bowl'},
            {'name': 'Vegetables', 'icon': 'eco'},
            {'name': 'Protein', 'icon': 'set_meal'},
          ],
          'kcal': 650,
          'minToServe': 10,
          'isTopMenu': false,
        },
        {
          'name': 'Mee Goreng Mamak',
          'description':
              'Spicy stir-fried yellow noodles with vegetables, tofu, and egg in mamak style.',
          'price': 5.50,
          'imageUrl':
              'https://www.resipikita.com/wp-content/uploads/2024/01/Resepi-Mee-Goreng-Mamak-Sedap.jpg',
          'category': 'Noodles',
          'mainIngredients': [
            {'name': 'Noodle', 'icon': 'ramen_dining'},
            {'name': 'Egg', 'icon': 'egg_alt'},
            {'name': 'Tofu', 'icon': 'emoji_nature'},
          ],
          'kcal': 590,
          'minToServe': 7,
          'isTopMenu': true,
        },
        {
          'name': 'Maggi Goreng',
          'description':
              'Fried instant noodles with vegetables, egg, and a savory seasoning.',
          'price': 5.00,
          'imageUrl':
              'https://www.newmalaysiankitchen.com/wp-content/uploads/2017/05/Easy-Maggi-Goreng-5-Ingredients.jpg',
          'category': 'Noodles',
          'mainIngredients': [
            {'name': 'Instant Noodle', 'icon': 'ramen_dining'},
            {'name': 'Egg', 'icon': 'egg_alt'},
            {'name': 'Vegetables', 'icon': 'eco'},
          ],
          'kcal': 510,
          'minToServe': 5,
          'isTopMenu': false,
        },
        {
          'name': 'Ayam Masak Merah',
          'description':
              'Chicken cooked in spicy, sweet, and tangy tomato-based gravy.',
          'price': 7.50,
          'imageUrl':
              'https://resepichenom.com/images/recipes/f2bce62ac27a2e825dfe3ad5f5d0ca3a11ac10a7.jpeg',
          'category': 'Indian',
          'mainIngredients': [
            {'name': 'Chicken', 'icon': 'set_meal'},
            {'name': 'Tomato', 'icon': 'emoji_food_beverage'},
            {'name': 'Chili', 'icon': 'local_fire_department'},
          ],
          'kcal': 480,
          'minToServe': 9,
          'isTopMenu': true,
        },
        {
          'name': 'Dhal Curry',
          'description':
              'Lentil curry slow-cooked with spices, perfect with rice or bread.',
          'price': 3.00,
          'imageUrl':
              'https://www.ambitiouskitchen.com/wp-content/uploads/fly-images/69004/The-Best-Dal-Ever-6-500x375-c.jpg',
          'category': 'Indian',
          'mainIngredients': [
            {'name': 'Lentil', 'icon': 'eco'},
            {'name': 'Spices', 'icon': 'restaurant'},
            {'name': 'Onion', 'icon': 'grass'},
          ],
          'kcal': 270,
          'minToServe': 6,
          'isTopMenu': false,
        },
        {
          'name': 'Chapati Set',
          'description':
              'Two pieces of chapati served with dhal curry or other sides.',
          'price': 4.50,
          'imageUrl':
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQbSEU8QBxle3gD9Xb1i_mkusOsoJ77sNQ5jg&s',
          'category': 'Indian',
          'mainIngredients': [
            {'name': 'Chapati', 'icon': 'bakery_dining'},
            {'name': 'Dhal', 'icon': 'eco'},
          ],
          'kcal': 310,
          'minToServe': 6,
          'isTopMenu': false,
        },
        {
          'name': 'Sirap Ais',
          'description': 'Sweet and refreshing iced rose syrup drink.',
          'price': 1.50,
          'imageUrl': 'https://qbistro.com/wp-content/uploads/2024/01/33-1.png',
          'category': 'Drinks',
          'mainIngredients': [
            {'name': 'Rose Syrup', 'icon': 'local_drink'},
            {'name': 'Ice', 'icon': 'ac_unit'},
          ],
          'kcal': 120,
          'minToServe': 2,
          'isTopMenu': false,
        },
        {
          'name': 'Limau Ais',
          'description': 'Chilled lime juice served with ice.',
          'price': 2.00,
          'imageUrl': 'https://media.myresipi.com/2020/11/myresipi-1205.png',
          'category': 'Drinks',
          'mainIngredients': [
            {'name': 'Lime', 'icon': 'spa'},
            {'name': 'Ice', 'icon': 'ac_unit'},
          ],
          'kcal': 80,
          'minToServe': 2,
          'isTopMenu': false,
        },
        {
          'name': 'Nescafe Tarik',
          'description':
              'Pulled Nescafe coffee blended with milk for a smooth taste.',
          'price': 2.50,
          'imageUrl':
              'https://media-cdn.tripadvisor.com/media/photo-s/0e/cd/e8/00/teh-tarik-nescafe-tarik.jpg',
          'category': 'Drinks',
          'mainIngredients': [
            {'name': 'Coffee', 'icon': 'coffee'},
            {'name': 'Milk', 'icon': 'local_drink'},
          ],
          'kcal': 104,
          'minToServe': 4,
          'isTopMenu': true,
        },
      ],
    },
    {
      'vendorId': 'itta-uid',
      'data': {
        'name': 'Itta Cafe',
        'email': 'itta@example.com',
        'phone': '0123456784',
        'address': 'Library Building, AIMST',
        'logoUrl':
            'https://www.nusentral.com/wp-content/uploads/2024/08/PHOTO-2024-08-07-11-20-58.jpg',
        'ownerUid': 'itta-uid',
        'openDays': [
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday',
          'Sunday',
        ],
        'openTime': '09:00',
        'closeTime': '22:00',
        'createdAt': FieldValue.serverTimestamp(),
      },
      "foods": [
        {
          "name": "Grilled Chicken Sandwich",
          "description": "Grilled chicken with lettuce and mayo",
          "price": 7.00,
          "imageUrl":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjGByeT1jUNjJL8XtxT_t2CQmd2hqN1eSz6Q&s",
          "category": "Western",
          "kcal": 520,
          "minToServe": 7,
          "isTopMenu": true,
          "ingredients": [
            {"name": "Egg", "icon": "egg_alt"},
            {"name": "Scallion", "icon": "grass"},
          ],
        },
        {
          "name": "Mac & Cheese",
          "description": "Creamy macaroni with cheddar",
          "price": 6.50,
          "imageUrl":
              "https://cdn.allotta.io/image/upload/v1718730174/dxp-images/brands/Recipes/global-recipes-heinz-nz/the-ultimate-mac-cheese/generated/the-ultimate-mac-cheese-767567.jpg",
          "category": "Western",
          "kcal": 610,
          "minToServe": 8,
          "isTopMenu": false,
          "ingredients": [
            {"name": "Noodle", "icon": "ramen_dining"},
            {"name": "Cheese", "icon": "set_meal"},
          ],
        },
        {
          "name": "Caesar Salad",
          "description": "Fresh salad with Caesar dressing",
          "price": 5.50,
          "imageUrl":
              "https://itsavegworldafterall.com/wp-content/uploads/2023/04/Avocado-Caesar-Salad-FI.jpg",
          "category": "Western",
          "kcal": 280,
          "minToServe": 5,
          "isTopMenu": true,
          "ingredients": [
            {"name": "Scallion", "icon": "grass"},
            {"name": "Egg", "icon": "egg_alt"},
          ],
        },
        {
          "name": "Chocolate Muffin",
          "description": "Rich muffin with chocolate chips",
          "price": 3.00,
          "imageUrl":
              "https://www.allrecipes.com/thmb/RdyL1EgIB0Qq_fr5HjdsAmcpMlU=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/228553-moist-chocolate-muffins-DDMFS-4x3-a9f73a46938547c99d921613dc167741.jpg",
          "category": "Pastry",
          "kcal": 430,
          "minToServe": 4,
          "isTopMenu": false,
          "ingredients": [
            {"name": "Egg", "icon": "egg_alt"},
          ],
        },
        {
          "name": "Croissant",
          "description": "Buttery flaky croissant",
          "price": 3.50,
          "imageUrl":
              "https://static01.nyt.com/images/2021/04/07/dining/06croissantsrex1/06croissantsrex1-mediumSquareAt3X.jpg",
          "category": "Pastry",
          "kcal": 320,
          "minToServe": 3,
          "isTopMenu": true,
          "ingredients": [
            {"name": "Egg", "icon": "egg_alt"},
          ],
        },
        {
          "name": "Blueberry Cheesecake",
          "description": "Creamy cheesecake with blueberry topping",
          "price": 4.50,
          "imageUrl":
              "https://www.mybakingaddiction.com/wp-content/uploads/2022/08/plated-blueberry-cheesecake-hero.jpg",
          "category": "Dessert",
          "kcal": 450,
          "minToServe": 6,
          "isTopMenu": false,
          "ingredients": [
            {"name": "Egg", "icon": "egg_alt"},
          ],
        },
        {
          "name": "Iced Latte",
          "description": "Cold espresso with milk",
          "price": 6.00,
          "imageUrl":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRWYtwckUUmEcT9NFf_vYuWD2BJQMqzAbiKuQ&s",
          "category": "Drinks",
          "kcal": 130,
          "minToServe": 3,
          "isTopMenu": true,
          "ingredients": [],
        },
        {
          "name": "Hot Chocolate",
          "description": "Warm cocoa drink with milk",
          "price": 5.00,
          "imageUrl":
              "https://bakerbynature.com/wp-content/uploads/2024/01/Hot-Chocolate-3.jpg",
          "category": "Drinks",
          "kcal": 190,
          "minToServe": 4,
          "isTopMenu": false,
          "ingredients": [],
        },
        {
          "name": "Lemon Iced Tea",
          "description": "Cold tea with lemon flavor",
          "price": 4.00,
          "imageUrl":
              "https://www.thesouthernthing.com/wp-content/uploads/2020/05/lemon-lime-tea-cocktail-5-735x1050.jpg",
          "category": "Drinks",
          "kcal": 90,
          "minToServe": 2,
          "isTopMenu": true,
          "ingredients": [],
        },
        {
          "name": "Espresso",
          "description": "Strong black coffee",
          "price": 3.50,
          "imageUrl":
              "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/10/54/20/2e/espress-coffee-house.jpg?w=1200&h=1200&s=1",
          "category": "Drinks",
          "kcal": 5,
          "minToServe": 2,
          "isTopMenu": false,
          "ingredients": [],
        },
      ],
    },
  ];

  for (final vendor in vendors) {
    final vendorId = vendor['vendorId'];
    final vendorData = vendor['data'] as Map<String, dynamic>;
    final foodItems = vendor['foods'] as List;

    final vendorRef = _firestore.collection('vendors').doc(vendorId as String?);

    // Upload vendor
    await vendorRef.set(vendorData);

    // Upload foods
    for (final food in foodItems) {
      await vendorRef.collection('foods').add({
        ...food,
        'isAvailable': true,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  print("✅ Vendors and food menus uploaded!");
}
