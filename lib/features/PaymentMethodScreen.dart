import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery_app/core/theme/app_theme.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String cardNumber = "";
  String cardHolder = "";
  String expiry = "";

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    fetchCardData();
  }

  Future<void> fetchCardData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('paymentMethods')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        setState(() {
          cardNumber = data['cardNumber'] ?? '';
          cardHolder = data['name'] ?? '';
          expiry = data['expiry'] ?? '';
        });
      }
    } catch (e) {
      print("Error fetching card: $e");
    }
  }

  void _showEditCardDialog(String docId) {
    final nameController = TextEditingController(text: cardHolder);
    final numberController = TextEditingController(text: cardNumber);
    final expiryController = TextEditingController(text: expiry);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Card'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Card Holder'),
              ),
              TextField(
                controller: numberController,
                decoration: const InputDecoration(labelText: 'Card Number'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: expiryController,
                decoration: const InputDecoration(labelText: 'Expiry (MM/YY)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: const Text('Save'),
            onPressed: () async {
              Navigator.of(context).pop();

              try {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('paymentMethods')
                    .doc(docId)
                    .update({
                      'name': nameController.text.trim(),
                      'cardNumber': numberController.text.trim(),
                      'expiry': expiryController.text.trim(),
                    });

                setState(() {
                  cardHolder = nameController.text.trim();
                  cardNumber = numberController.text.trim();
                  expiry = expiryController.text.trim();
                });
              } catch (e) {
                print("Failed to update card: $e");
              }
            },
          ),
        ],
      ),
    );
  }

  void _showAddCardDialog() {
    final nameController = TextEditingController();
    final numberController = TextEditingController();
    final expiryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Card'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Card Holder'),
              ),
              TextField(
                controller: numberController,
                decoration: const InputDecoration(labelText: 'Card Number'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: expiryController,
                decoration: const InputDecoration(labelText: 'Expiry (MM/YY)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: const Text('Add'),
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              if (user == null) return;

              final cardData = {
                'name': nameController.text.trim(),
                'cardNumber': numberController.text.trim(),
                'expiry': expiryController.text.trim(),
                'timestamp': FieldValue.serverTimestamp(),
              };

              try {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .collection('paymentMethods')
                    .add(cardData);

                Navigator.of(context).pop();

                setState(() {
                  cardNumber = (cardData['cardNumber'] ?? '').toString();
                  cardHolder = (cardData['name'] ?? '').toString();
                  expiry = (cardData['expiry'] ?? '').toString();
                });
              } catch (e) {
                print("Failed to add card: $e");
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleSection(),
              const SizedBox(height: 20.0),
              if (cardNumber.isNotEmpty)
                _buildCreditCard(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  cardExpiration: expiry,
                  cardHolder: cardHolder,
                  cardNumber:
                      '**** **** **** ${cardNumber.substring(cardNumber.length - 4)}',
                  context: context,
                ),
              const SizedBox(height: 20.0),
              _buildAddCardButton(icon: Icons.add, color: AppTheme.accentGreen),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Payment Method",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            "Select a credit card you wish to use.",
            style: TextStyle(fontSize: 18, color: Colors.black45),
          ),
        ),
      ],
    );
  }

  Widget _buildCreditCard({
    required Color color,
    required String cardNumber,
    required String cardHolder,
    required String cardExpiration,
    required BuildContext context,
  }) {
    return Container(
      height: 180,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 20,
            top: 20,
            child: Image.asset("assets/chip.png", height: 40),
          ),
          Positioned(
            right: 20,
            top: 20,
            child: Row(
              children: [
                Image.asset("assets/mastercard.png", height: 50),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    // Get the doc ID of the latest card
                    FirebaseAuth.instance.currentUser?.uid;
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection('paymentMethods')
                        .orderBy('timestamp', descending: true)
                        .limit(1)
                        .get()
                        .then((snapshot) {
                          if (snapshot.docs.isNotEmpty) {
                            _showEditCardDialog(snapshot.docs.first.id);
                          }
                        });
                  },
                ),
              ],
            ),
          ),
          Positioned(
            left: 20,
            bottom: 60,
            child: Text(
              cardNumber,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
          ),
          Positioned(
            left: 20,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Card Holder",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  cardHolder,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
          Positioned(
            right: 20,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  "Expires",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  cardExpiration,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddCardButton({required IconData icon, required Color color}) {
    return GestureDetector(
      onTap: _showAddCardDialog,
      child: Container(
        height: 180,
        width: 320,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black26, width: 2.0),
        ),
        child: Center(child: Icon(icon, color: color, size: 50)),
      ),
    );
  }
}
