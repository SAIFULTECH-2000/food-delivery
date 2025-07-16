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
          'imageUrl': 'https://www.andy-cooks.com/cdn/shop/articles/20231116072724-c2-a9andy_cooks_thumbnails_nasi_lemak_01.jpg?v=1700389619',
          'category': 'Local',
        },
        {
          'name': 'Roti Bakar',
          'description': 'Grilled bread with kaya and butter',
          'price': 3.00,
          'imageUrl': 'https://wiratech.co.id/wp-content/uploads/2018/03/peluang-bisnis-roti-bakar-dan-analisa-usahanya-pengusaha-sukses.jpg',
          'category': 'Breakfast',
        },
        {
          'name': 'Half Boiled Eggs',
          'description': '2 soft boiled eggs with soy sauce and pepper',
          'price': 2.50,
          'imageUrl': 'https://www.ajinomotofoodbizpartner.com.my/wp-content/uploads/2023/09/Half-boiled-Egg-thumbnail-03.jpg',
          'category': 'Breakfast',
        },
        {
          'name': 'Mee Hoon Goreng',
          'description': 'Stir-fried vermicelli noodles',
          'price': 4.50,
          'imageUrl': 'https://www.maggi.my/sites/default/files/srh_recipes/0a0a73c86c37d751860d480cdcffbc9c.jpg',
          'category': 'Local',
        },
        {
          'name': 'Kaya Puff',
          'description': 'Crispy pastry with kaya filling',
          'price': 2.00,
          'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTGLKmEMtcnMs9Fflgrd2kWhrOpMgAeVLqQwA&s',
          'category': 'Snacks',
        },
        {
          'name': 'Curry Puff',
          'description': 'Pastry with curried potato filling',
          'price': 2.00,
          'imageUrl': 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Karipap_Daging.jpg/960px-Karipap_Daging.jpg',
          'category': 'Snacks',
        },
        {
          'name': 'Fried Spring Roll',
          'description': 'Vegetable-filled fried rolls',
          'price': 2.50,
          'imageUrl': 'https://thai-foodie.com/wp-content/uploads/2023/07/thai-egg-rolls-redo.jpg',
          'category': 'Snacks',
        },
        {
          'name': 'Teh Tarik',
          'description': 'Classic pulled milk tea',
          'price': 2.00,
          'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQbPLBRQf7HXIop-YgG_oAqWee12BExUqB-5w&s',
          'category': 'Drinks',
        },
        {
          'name': 'Kopi O',
          'description': 'Black coffee',
          'price': 1.80,
          'imageUrl': 'https://munchmalaysia.com/wp-content/uploads/2024/01/Kopi-O-1024x709.jpg',
          'category': 'Drinks',
        },
        {
          'name': 'Milo Ais',
          'description': 'Iced chocolate malt drink',
          'price': 2.50,
          'imageUrl': 'https://munchmalaysia.com/wp-content/uploads/2023/11/milo-ais-683x1024.jpg',
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
      'imageUrl': 'https://nomadette.com/wp-content/uploads/2025/01/Honey-Roasted-Chicken-Rice.jpg',
      'category': 'Rice',
    },
    {
      'name': 'Nasi Campur',
      'description': 'Mixed rice with your choice of dishes',
      'price': 7.00,
      'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxeob0RTrSBBVQh1aBrk-p4Vrnne_dH2Tqqw&s',
      'category': 'Rice',
    },
    {
      'name': 'Mee Goreng Mamak',
      'description': 'Stir-fried noodles mamak style',
      'price': 5.50,
      'imageUrl': 'https://www.resipikita.com/wp-content/uploads/2024/01/Resepi-Mee-Goreng-Mamak-Sedap.jpg',
      'category': 'Noodles',
    },
    {
      'name': 'Maggi Goreng',
      'description': 'Fried instant noodles with egg and veggies',
      'price': 5.00,
      'imageUrl': 'https://www.newmalaysiankitchen.com/wp-content/uploads/2017/05/Easy-Maggi-Goreng-5-Ingredients.jpg',
      'category': 'Noodles',
    },
    {
      'name': 'Ayam Masak Merah',
      'description': 'Chicken in spicy tomato gravy',
      'price': 7.50,
      'imageUrl': 'https://resepichenom.com/images/recipes/f2bce62ac27a2e825dfe3ad5f5d0ca3a11ac10a7.jpeg',
      'category': 'Indian',
    },
    {
      'name': 'Dhal Curry',
      'description': 'Lentil curry, great with rice',
      'price': 3.00,
      'imageUrl': 'https://www.ambitiouskitchen.com/wp-content/uploads/fly-images/69004/The-Best-Dal-Ever-6-500x375-c.jpg',
      'category': 'Indian',
    },
    {
      'name': 'Chapati Set',
      'description': '2 pieces chapati with curry',
      'price': 4.50,
      'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQbSEU8QBxle3gD9Xb1i_mkusOsoJ77sNQ5jg&s',
      'category': 'Indian',
    },
    {
      'name': 'Sirap Ais',
      'description': 'Iced rose syrup drink',
      'price': 1.50,
      'imageUrl': 'https://qbistro.com/wp-content/uploads/2024/01/33-1.png',
      'category': 'Drinks',
    },
    {
      'name': 'Limau Ais',
      'description': 'Iced lime drink',
      'price': 2.00,
      'imageUrl': 'https://media.myresipi.com/2020/11/myresipi-1205.png',
      'category': 'Drinks',
    },
    {
      'name': 'Nescafe Tarik',
      'description': 'Pulled Nescafe with milk',
      'price': 2.50,
      'imageUrl': 'https://media-cdn.tripadvisor.com/media/photo-s/0e/cd/e8/00/teh-tarik-nescafe-tarik.jpg',
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
      'imageUrl': 'https://easyindiancookbook.com/wp-content/uploads/2023/02/indian-vegetarian-thali-5-jpg.webp',
      'category': 'South Indian',
    },
    {
      'name': 'Idli',
      'description': 'Soft rice cakes with sambar',
      'price': 3.00,
      'imageUrl': 'https://maayeka.com/wp-content/uploads/2013/10/soft-idli-recipe.jpg',
      'category': 'South Indian',
    },
    {
      'name': 'Vadai',
      'description': 'Savory deep-fried snack',
      'price': 1.50,
      'imageUrl': 'https://i0.wp.com/cookingfromheart.com/wp-content/uploads/2016/10/Masala-Vadai-3.jpg?resize=720%2C508&ssl=1',
      'category': 'Snacks',
    },
    {
      'name': 'Parotta Set',
      'description': '2 parotta with curry',
      'price': 5.50,
      'imageUrl': 'https://palakkadbusiness.com/Gangashankaram/wp-content/uploads/sites/79/2023/11/porotta.jpg',
      'category': 'Indian',
    },
    {
      'name': 'Rasam Rice',
      'description': 'Spicy tamarind soup with rice',
      'price': 4.00,
      'imageUrl': 'https://smithakalluraya.com/wp-content/uploads/2025/04/One-pot-rasam-rice-recipe-500x500.jpg',
      'category': 'South Indian',
    },
    {
      'name': 'Sambar Rice',
      'description': 'Lentil curry rice',
      'price': 4.50,
      'imageUrl': 'https://rakskitchen.net/wp-content/uploads/2011/03/sambar-sadam_thumb4-403x375.jpg',
      'category': 'Vegetarian',
    },
    {
      'name': 'Lassi',
      'description': 'Yogurt-based drink',
      'price': 3.00,
      'imageUrl': 'https://www.subbuskitchen.com/wp-content/uploads/2014/05/Lassi_Final4.jpg',
      'category': 'Drinks',
    },
    {
      'name': 'Masala Tea',
      'description': 'Spiced Indian tea',
      'price': 2.50,
      'imageUrl': 'https://cdn.shopify.com/s/files/1/0758/6929/0779/files/Masala_Tea_-_Annams_Recipes_Shop_2_480x480.jpg?v=1732347934',
      'category': 'Drinks',
    },
    {
      'name': 'Filter Coffee',
      'description': 'Traditional South Indian coffee',
      'price': 2.50,
      'imageUrl': 'https://www.forestcloud.com.my/cdn/shop/products/DSC_0789.jpg?v=1717493015&width=480',
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
      'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjGByeT1jUNjJL8XtxT_t2CQmd2hqN1eSz6Q&s',
      'category': 'Western',
    },
    {
      'name': 'Mac & Cheese',
      'description': 'Creamy macaroni with cheddar',
      'price': 6.50,
      'imageUrl': 'https://cdn.allotta.io/image/upload/v1718730174/dxp-images/brands/Recipes/global-recipes-heinz-nz/the-ultimate-mac-cheese/generated/the-ultimate-mac-cheese-767567.jpg',
      'category': 'Western',
    },
    {
      'name': 'Caesar Salad',
      'description': 'Fresh salad with Caesar dressing',
      'price': 5.50,
      'imageUrl': 'https://itsavegworldafterall.com/wp-content/uploads/2023/04/Avocado-Caesar-Salad-FI.jpg',
      'category': 'Western',
    },
    {
      'name': 'Chocolate Muffin',
      'description': 'Rich muffin with chocolate chips',
      'price': 3.00,
      'imageUrl': 'https://www.allrecipes.com/thmb/RdyL1EgIB0Qq_fr5HjdsAmcpMlU=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/228553-moist-chocolate-muffins-DDMFS-4x3-a9f73a46938547c99d921613dc167741.jpg',
      'category': 'Pastry',
    },
    {
      'name': 'Croissant',
      'description': 'Buttery flaky croissant',
      'price': 3.50,
      'imageUrl': 'https://static01.nyt.com/images/2021/04/07/dining/06croissantsrex1/06croissantsrex1-mediumSquareAt3X.jpg',
      'category': 'Pastry',
    },
    {
      'name': 'Blueberry Cheesecake',
      'description': 'Creamy cheesecake with blueberry topping',
      'price': 4.50,
      'imageUrl': 'https://www.mybakingaddiction.com/wp-content/uploads/2022/08/plated-blueberry-cheesecake-hero.jpg',
      'category': 'Dessert',
    },
    {
      'name': 'Iced Latte',
      'description': 'Cold espresso with milk',
      'price': 6.00,
      'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRWYtwckUUmEcT9NFf_vYuWD2BJQMqzAbiKuQ&s',
      'category': 'Drinks',
    },
    {
      'name': 'Hot Chocolate',
      'description': 'Warm cocoa drink with milk',
      'price': 5.00,
      'imageUrl': 'https://bakerbynature.com/wp-content/uploads/2024/01/Hot-Chocolate-3.jpg',
      'category': 'Drinks',
    },
    {
      'name': 'Lemon Iced Tea',
      'description': 'Cold tea with lemon flavor',
      'price': 4.00,
      'imageUrl': 'https://www.thesouthernthing.com/wp-content/uploads/2020/05/lemon-lime-tea-cocktail-5-735x1050.jpg',
      'category': 'Drinks',
    },
    {
      'name': 'Espresso',
      'description': 'Strong black coffee',
      'price': 3.50,
      'imageUrl': 'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/10/54/20/2e/espress-coffee-house.jpg?w=1200&h=1200&s=1',
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
