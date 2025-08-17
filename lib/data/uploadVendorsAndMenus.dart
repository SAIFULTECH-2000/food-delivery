import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> uploadVendorsAndMenus() async {
  final vendors = [
    {
      'vendorId': 'kopitiam-uid',
      'data': {
        'name': 'Kopitiam',
        'email': 'kopitiam@aimst.com',
        'password': 'abcd1234',
        'phone': '0123456781',
        'address': 'Student Centre, AIMST',
        'logoUrl':
            'https://firebasestorage.googleapis.com/v0/b/food-delivery-4a375.firebasestorage.app/o/vendors%2FWhatsApp%20Image%202025-08-05%20at%209.31.49%20PM%20(1).jpeg?alt=media&token=581b1175-c70a-40b1-b801-73c066c50c0f',
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
          "isVeg": false,
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
          "isVeg": true,
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
          "isVeg": true,
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
          "isVeg": true,
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
          "isVeg": true,
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
          "isVeg":
              false, // assuming this version has meat as suggested by the image name and typical filling
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
          "isVeg": true,
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
          "isVeg": true,
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
          "isVeg": true,
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
          "isVeg": true,
        },
      ],
    },
    {
      'vendorId': 'jaya-uid',
      'data': {
        'name': 'Jaya Catering',
        'email': 'jaya@aimst.com',
        'password': 'abcd1234',
        'phone': '0123456782',
        'address': 'Cafeteria Block A, AIMST',
        'logoUrl':
            'https://firebasestorage.googleapis.com/v0/b/food-delivery-4a375.firebasestorage.app/o/vendors%2FWhatsApp%20Image%202025-08-05%20at%209.31.50%20PM.jpeg?alt=media&token=6c9fd1ae-80c4-4a7c-aaf4-4a9c5638ced6',
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
          'isVeg': false,
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
          'isVeg': false, // "Protein" usually includes meat/fish
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
          'isVeg': true,
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
          'isVeg': true,
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
          'isVeg': false,
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
          'isVeg': true,
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
          'isVeg': true,
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
          'isVeg': true,
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
          'isVeg': true,
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
          'isVeg': true,
        },
      ],
    },
    {
      'vendorId': 'itta-uid',
      'data': {
        'name': 'C Delight Aroma Kitchen',
        'email': 'Aroma@aimst.com',
        'password': 'abcd1234',
        'phone': '0123456784',
        'address': 'Library Building, AIMST',
        'logoUrl':
            'https://firebasestorage.googleapis.com/v0/b/food-delivery-4a375.firebasestorage.app/o/vendors%2FWhatsApp%20Image%202025-08-05%20at%209.31.49%20PM%20(2).jpeg?alt=media&token=c8a7d842-ade4-4500-83f4-5468cafd7400',
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
          "isVeg": false,
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
          "isVeg": true,
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
          "isVeg": true,
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
          "isVeg": true,
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
          "isVeg": true,
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
          "isVeg": true,
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
          "isVeg": true,
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
          "isVeg": true,
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
          "isVeg": true,
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
          "isVeg": true,
        },
      ],
    },
    {
      'vendorId': 'agathiyan-uid',
      'data': {
        'name': 'Agathiyan Kitchen',
        'email': 'agathiyan@example.com',
        'password': 'abcd1234',
        'phone': '0123456783',
        'address': 'AIMST Food Court',
        'logoUrl': 'https://example.com/agathiyan.png',
        'ownerUid': 'agathiyan-uid',
        'openDays': [
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday',
        ],
        'openTime': '10:00',
        'closeTime': '21:00',
        'createdAt': FieldValue.serverTimestamp(),
      },
      "foods": [
        {
          "name": "Vegetarian Thali",
          "description": "Indian meal set with rice and curries",
          "price": 6.50,
          "imageUrl":
              "https://upload.wikimedia.org/wikipedia/commons/thumb/4/49/Vegetarian_Curry.jpeg/640px-Vegetarian_Curry.jpeg",
          "category": "Indian",
          "kcal": 650,
          "minToServe": 10,
          "isTopMenu": true,
          "ingredients": [
            {"name": "Rice", "icon": "rice_bowl"},
            {"name": "Vegetables", "icon": "spa"},
          ],
          "isVeg": true,
        },
        {
          "name": "Dosa",
          "description": "South Indian crepe with chutney",
          "price": 3.50,
          "imageUrl":
              "https://upload.wikimedia.org/wikipedia/commons/9/9f/Dosa_at_Sri_Ganesha_Restauran%2C_Bangkok_%2844570742744%29.jpg",
          "category": "South Indian",
          "kcal": 180,
          "minToServe": 5,
          "isTopMenu": false,
          "ingredients": [
            {"name": "Rice", "icon": "rice_bowl"},
            {"name": "Lentil", "icon": "grass"},
          ],
          "isVeg": true,
        },
        {
          "name": "Idli",
          "description": "Soft rice cakes with sambar",
          "price": 3.00,
          "imageUrl":
              "https://maayeka.com/wp-content/uploads/2013/10/soft-idli-recipe.jpg",
          "category": "South Indian",
          "kcal": 150,
          "minToServe": 4,
          "isTopMenu": true,
          "ingredients": [
            {"name": "Rice", "icon": "rice_bowl"},
            {"name": "Lentil", "icon": "grass"},
          ],
          "isVeg": true,
        },
        {
          "name": "Vadai",
          "description": "Savory deep-fried snack",
          "price": 1.50,
          "imageUrl":
              "https://www.indianhealthyrecipes.com/wp-content/uploads/2015/08/masala-vada-1.jpg",
          "category": "Snacks",
          "kcal": 200,
          "minToServe": 3,
          "isTopMenu": false,
          "ingredients": [
            {"name": "Lentil", "icon": "grass"},
            {"name": "Oil", "icon": "water_drop"},
          ],
          "isVeg": true,
        },
        {
          "name": "Parotta Set",
          "description": "2 parotta with curry",
          "price": 5.50,
          "imageUrl":
              "https://palakkadbusiness.com/Gangashankaram/wp-content/uploads/sites/79/2023/11/porotta.jpg",
          "category": "Indian",
          "kcal": 550,
          "minToServe": 8,
          "isTopMenu": true,
          "ingredients": [
            {"name": "Wheat", "icon": "bakery_dining"},
            {"name": "Oil", "icon": "water_drop"},
          ],
          "isVeg": true,
        },
        {
          "name": "Rasam Rice",
          "description": "Spicy tamarind soup with rice",
          "price": 4.00,
          "imageUrl":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSiRBeUnRCjB3s3mrgG3xuwyvA6pA5sl75jFw&s",
          "category": "South Indian",
          "kcal": 300,
          "minToServe": 5,
          "isTopMenu": false,
          "ingredients": [
            {"name": "Tamarind", "icon": "eco"},
            {"name": "Rice", "icon": "rice_bowl"},
          ],
          "isVeg": true,
        },
        {
          "name": "Sambar Rice",
          "description": "Lentil curry rice",
          "price": 4.50,
          "imageUrl":
              "https://rakskitchen.net/wp-content/uploads/2011/03/sambar-sadam_thumb4-403x375.jpg",
          "category": "Vegetarian",
          "kcal": 320,
          "minToServe": 5,
          "isTopMenu": true,
          "ingredients": [
            {"name": "Lentil", "icon": "grass"},
            {"name": "Rice", "icon": "rice_bowl"},
          ],
          "isVeg": true,
        },
        {
          "name": "Lassi",
          "description": "Yogurt-based drink",
          "price": 3.00,
          "imageUrl":
              "https://assets.tmecosys.com/image/upload/t_web_rdp_recipe_584x480_1_5x/img/recipe/ras/Assets/5F34C0E8-8A5A-4ABF-B903-57975CF70D99/Derivates/06BE0235-A4B9-4952-83DF-D29EB2D15074.jpg",
          "category": "Drinks",
          "kcal": 180,
          "minToServe": 2,
          "isTopMenu": false,
          "ingredients": [
            {"name": "Yogurt", "icon": "icecream"},
          ],
          "isVeg": true,
        },
        {
          "name": "Masala Tea",
          "description": "Spiced Indian tea",
          "price": 2.50,
          "imageUrl":
              "https://cdn.shopify.com/s/files/1/0758/6929/0779/files/Masala_Tea_-_Annams_Recipes_Shop_2_480x480.jpg?v=1732347934",
          "category": "Drinks",
          "kcal": 90,
          "minToServe": 3,
          "isTopMenu": true,
          "ingredients": [
            {"name": "Tea", "icon": "local_cafe"},
            {"name": "Milk", "icon": "local_drink"},
          ],
          "isVeg": true,
        },
        {
          "name": "Filter Coffee",
          "description": "Traditional South Indian coffee",
          "price": 2.50,
          "imageUrl":
              "https://www.saffrontrail.com/wp-content/uploads/2006/08/recipe-to-make-filter-kaapi-how-to.1024x1024-1.jpg",
          "category": "Drinks",
          "kcal": 70,
          "minToServe": 3,
          "isTopMenu": false,
          "ingredients": [
            {"name": "Coffee", "icon": "coffee"},
            {"name": "Milk", "icon": "local_drink"},
          ],
          "isVeg": true,
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
