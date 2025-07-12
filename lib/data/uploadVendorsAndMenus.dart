import 'package:cloud_firestore/cloud_firestore.dart';

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
        'logoUrl': 'https://example.com/kopitiam.png',
        'ownerUid': 'kopitiam-uid',
        'openDays': ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
        'openTime': '07:30',
        'closeTime': '16:00',
        'createdAt': FieldValue.serverTimestamp(),
      },
      'foods': [
        {
          'name': 'Nasi Lemak',
          'description': 'Fragrant rice with sambal, egg, and anchovies',
          'price': 5.00,
          'imageUrl': 'https://example.com/nasilemak.jpg',
          'category': 'Local',
        },
        {
          'name': 'Roti Bakar',
          'description': 'Grilled bread with kaya and butter',
          'price': 3.00,
          'imageUrl': 'https://example.com/roti.jpg',
          'category': 'Breakfast',
        },
        {
          'name': 'Half Boiled Eggs',
          'description': '2 soft boiled eggs with soy sauce and pepper',
          'price': 2.50,
          'imageUrl': 'https://example.com/eggs.jpg',
          'category': 'Breakfast',
        },
        {
          'name': 'Mee Hoon Goreng',
          'description': 'Stir-fried vermicelli noodles',
          'price': 4.50,
          'imageUrl': 'https://example.com/meehun.jpg',
          'category': 'Local',
        },
        {
          'name': 'Kaya Puff',
          'description': 'Crispy pastry with kaya filling',
          'price': 2.00,
          'imageUrl': 'https://example.com/kayapuff.jpg',
          'category': 'Snacks',
        },
        {
          'name': 'Curry Puff',
          'description': 'Pastry with curried potato filling',
          'price': 2.00,
          'imageUrl': 'https://example.com/currypuff.jpg',
          'category': 'Snacks',
        },
        {
          'name': 'Fried Spring Roll',
          'description': 'Vegetable-filled fried rolls',
          'price': 2.50,
          'imageUrl': 'https://example.com/springroll.jpg',
          'category': 'Snacks',
        },
        {
          'name': 'Teh Tarik',
          'description': 'Classic pulled milk tea',
          'price': 2.00,
          'imageUrl': 'https://example.com/tehtarik.jpg',
          'category': 'Drinks',
        },
        {
          'name': 'Kopi O',
          'description': 'Black coffee',
          'price': 1.80,
          'imageUrl': 'https://example.com/kopio.jpg',
          'category': 'Drinks',
        },
        {
          'name': 'Milo Ais',
          'description': 'Iced chocolate malt drink',
          'price': 2.50,
          'imageUrl': 'https://example.com/miloais.jpg',
          'category': 'Drinks',
        },
      ]
    },
// Add other vendors the same way:
{
  'vendorId': 'jaya-uid',
  'data': {
    'name': 'Jaya Catering',
    'email': 'jaya@example.com',
    'phone': '0123456782',
    'address': 'Cafeteria Block A, AIMST',
    'logoUrl': 'https://example.com/jaya.png',
    'ownerUid': 'jaya-uid',
    'openDays': ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
    'openTime': '08:00',
    'closeTime': '19:00',
    'createdAt': FieldValue.serverTimestamp(),
  },
  'foods': [
    {
      'name': 'Chicken Rice',
      'description': 'Tender chicken with rice and chili sauce',
      'price': 6.50,
      'imageUrl': 'https://example.com/chickenrice.jpg',
      'category': 'Rice',
    },
    {
      'name': 'Nasi Campur',
      'description': 'Mixed rice with your choice of dishes',
      'price': 7.00,
      'imageUrl': 'https://example.com/nasicampur.jpg',
      'category': 'Rice',
    },
    {
      'name': 'Mee Goreng Mamak',
      'description': 'Stir-fried noodles mamak style',
      'price': 5.50,
      'imageUrl': 'https://example.com/meemamak.jpg',
      'category': 'Noodles',
    },
    {
      'name': 'Maggi Goreng',
      'description': 'Fried instant noodles with egg and veggies',
      'price': 5.00,
      'imageUrl': 'https://example.com/maggi.jpg',
      'category': 'Noodles',
    },
    {
      'name': 'Ayam Masak Merah',
      'description': 'Chicken in spicy tomato gravy',
      'price': 7.50,
      'imageUrl': 'https://example.com/ayam.jpg',
      'category': 'Indian',
    },
    {
      'name': 'Dhal Curry',
      'description': 'Lentil curry, great with rice',
      'price': 3.00,
      'imageUrl': 'https://example.com/dhal.jpg',
      'category': 'Indian',
    },
    {
      'name': 'Chapati Set',
      'description': '2 pieces chapati with curry',
      'price': 4.50,
      'imageUrl': 'https://example.com/chapati.jpg',
      'category': 'Indian',
    },
    {
      'name': 'Sirap Ais',
      'description': 'Iced rose syrup drink',
      'price': 1.50,
      'imageUrl': 'https://example.com/sirap.jpg',
      'category': 'Drinks',
    },
    {
      'name': 'Limau Ais',
      'description': 'Iced lime drink',
      'price': 2.00,
      'imageUrl': 'https://example.com/limau.jpg',
      'category': 'Drinks',
    },
    {
      'name': 'Nescafe Tarik',
      'description': 'Pulled Nescafe with milk',
      'price': 2.50,
      'imageUrl': 'https://example.com/nescafe.jpg',
      'category': 'Drinks',
    },
  ],
},
{
  'vendorId': 'agathiyan-uid',
  'data': {
    'name': 'Agathiyan Kitchen',
    'email': 'agathiyan@example.com',
    'phone': '0123456783',
    'address': 'AIMST Food Court',
    'logoUrl': 'https://example.com/agathiyan.png',
    'ownerUid': 'agathiyan-uid',
    'openDays': ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
    'openTime': '10:00',
    'closeTime': '21:00',
    'createdAt': FieldValue.serverTimestamp(),
  },
  'foods': [
    {
      'name': 'Vegetarian Thali',
      'description': 'Indian meal set with rice and curries',
      'price': 6.50,
      'imageUrl': 'https://example.com/thali.jpg',
      'category': 'Indian',
    },
    {
      'name': 'Dosa',
      'description': 'South Indian crepe with chutney',
      'price': 3.50,
      'imageUrl': 'https://example.com/dosa.jpg',
      'category': 'South Indian',
    },
    {
      'name': 'Idli',
      'description': 'Soft rice cakes with sambar',
      'price': 3.00,
      'imageUrl': 'https://example.com/idli.jpg',
      'category': 'South Indian',
    },
    {
      'name': 'Vadai',
      'description': 'Savory deep-fried snack',
      'price': 1.50,
      'imageUrl': 'https://example.com/vadai.jpg',
      'category': 'Snacks',
    },
    {
      'name': 'Parotta Set',
      'description': '2 parotta with curry',
      'price': 5.50,
      'imageUrl': 'https://example.com/parotta.jpg',
      'category': 'Indian',
    },
    {
      'name': 'Rasam Rice',
      'description': 'Spicy tamarind soup with rice',
      'price': 4.00,
      'imageUrl': 'https://example.com/rasam.jpg',
      'category': 'South Indian',
    },
    {
      'name': 'Sambar Rice',
      'description': 'Lentil curry rice',
      'price': 4.50,
      'imageUrl': 'https://example.com/sambar.jpg',
      'category': 'Vegetarian',
    },
    {
      'name': 'Lassi',
      'description': 'Yogurt-based drink',
      'price': 3.00,
      'imageUrl': 'https://example.com/lassi.jpg',
      'category': 'Drinks',
    },
    {
      'name': 'Masala Tea',
      'description': 'Spiced Indian tea',
      'price': 2.50,
      'imageUrl': 'https://example.com/masala.jpg',
      'category': 'Drinks',
    },
    {
      'name': 'Filter Coffee',
      'description': 'Traditional South Indian coffee',
      'price': 2.50,
      'imageUrl': 'https://example.com/filtercoffee.jpg',
      'category': 'Drinks',
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
    'logoUrl': 'https://example.com/itta.png',
    'ownerUid': 'itta-uid',
    'openDays': ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],
    'openTime': '09:00',
    'closeTime': '22:00',
    'createdAt': FieldValue.serverTimestamp(),
  },
  'foods': [
    {
      'name': 'Grilled Chicken Sandwich',
      'description': 'Grilled chicken with lettuce and mayo',
      'price': 7.00,
      'imageUrl': 'https://example.com/sandwich.jpg',
      'category': 'Western',
    },
    {
      'name': 'Mac & Cheese',
      'description': 'Creamy macaroni with cheddar',
      'price': 6.50,
      'imageUrl': 'https://example.com/mac.jpg',
      'category': 'Western',
    },
    {
      'name': 'Caesar Salad',
      'description': 'Fresh salad with Caesar dressing',
      'price': 5.50,
      'imageUrl': 'https://example.com/salad.jpg',
      'category': 'Western',
    },
    {
      'name': 'Chocolate Muffin',
      'description': 'Rich muffin with chocolate chips',
      'price': 3.00,
      'imageUrl': 'https://example.com/muffin.jpg',
      'category': 'Pastry',
    },
    {
      'name': 'Croissant',
      'description': 'Buttery flaky croissant',
      'price': 3.50,
      'imageUrl': 'https://example.com/croissant.jpg',
      'category': 'Pastry',
    },
    {
      'name': 'Blueberry Cheesecake',
      'description': 'Creamy cheesecake with blueberry topping',
      'price': 4.50,
      'imageUrl': 'https://example.com/cheesecake.jpg',
      'category': 'Dessert',
    },
    {
      'name': 'Iced Latte',
      'description': 'Cold espresso with milk',
      'price': 6.00,
      'imageUrl': 'https://example.com/latte.jpg',
      'category': 'Drinks',
    },
    {
      'name': 'Hot Chocolate',
      'description': 'Warm cocoa drink with milk',
      'price': 5.00,
      'imageUrl': 'https://example.com/hotchoc.jpg',
      'category': 'Drinks',
    },
    {
      'name': 'Lemon Iced Tea',
      'description': 'Cold tea with lemon flavor',
      'price': 4.00,
      'imageUrl': 'https://example.com/icetea.jpg',
      'category': 'Drinks',
    },
    {
      'name': 'Espresso',
      'description': 'Strong black coffee',
      'price': 3.50,
      'imageUrl': 'https://example.com/espresso.jpg',
      'category': 'Drinks',
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
