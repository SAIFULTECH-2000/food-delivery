import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_delivery_app/features/PaymentReceiptScreen.dart';
import 'package:food_delivery_app/features/dashboard_Screen.dart';
import 'package:toastification/toastification.dart';

class ConfirmPaymentScreen extends StatefulWidget {
  final double amount;
  const ConfirmPaymentScreen({super.key, required this.amount});

  @override
  State<ConfirmPaymentScreen> createState() => _ConfirmPaymentScreenState();
}

class _ConfirmPaymentScreenState extends State<ConfirmPaymentScreen> {
  final pinController = TextEditingController();
  String maskedPhone = "";

  @override
  void initState() {
    super.initState();
    _loadPhoneNumber();
  }

  void _loadPhoneNumber() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final uid = user.uid;

    // Get phone from Firestore under users/{uid}/phone
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get();

    if (doc.exists && doc.data() != null) {
      final phone = doc.data()!["phone"] ?? "+60**********";

      if (phone.length > 7) {
        maskedPhone =
            phone.substring(0, 3) + "*****" + phone.substring(phone.length - 4);
      } else {
        maskedPhone = phone;
      }
    } else {
      maskedPhone = "+60**********"; // fallback if no phone found
    }

    setState(() {});
  }

  void _confirmPin() {
    if (pinController.text.length == 6) {
      // Show toast instead of snackbar
      toastification.show(
        context: context,
        type: ToastificationType.success,
        title: const Text("PIN accepted"),
        description: const Text("Processing payment..."),
        autoCloseDuration: const Duration(seconds: 3),
      );

      // After toast, clear cart & place order
      _clearUserCart();
    } else {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        title: const Text("Invalid PIN"),
        description: const Text("Please enter a 6-digit PIN"),
        autoCloseDuration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> _clearUserCart() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        debugPrint("User not logged in.");
        return;
      }

      final cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart');

      final cartSnapshot = await cartRef.get();

      if (cartSnapshot.docs.isEmpty) {
        debugPrint("Cart is empty.");
        return;
      }

      double totalPrice = 0.0;
      String? restaurantName;
      final Map<String, dynamic> items = {};

      for (final cartItem in cartSnapshot.docs) {
        final data = cartItem.data();
        final itemId = cartItem.id;

        restaurantName = data['restaurantName'];
        final price = (data['price'] as num).toDouble();
        final qty = (data['quantity'] as num).toInt();
        totalPrice += price * qty;

        items[itemId] = {
          'name': data['name'],
          'price': price,
          'quantity': qty,
          'imageUrl': data['imageUrl'],
        };
      }

      final myOrdersRef = FirebaseFirestore.instance.collection('myOrders');
      final newOrderRef = myOrdersRef.doc();

      await newOrderRef.set({
        'restaurantName': restaurantName ?? 'Unknown',
        'userId': user.uid,
        'date': FieldValue.serverTimestamp(),
        'totalPrice': totalPrice,
        'items': items,
      });

      final batch = FirebaseFirestore.instance.batch();
      for (final cartItem in cartSnapshot.docs) {
        batch.delete(cartItem.reference);
      }
      await batch.commit();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentReceiptScreen(
            amount: widget.amount,
            receiver: restaurantName ?? "Unknown", // or any receiver
            referenceNo: DateTime.now().millisecondsSinceEpoch
                .toString(), // simple unique ref
            dateTime: DateTime.now(),
            method: "eWallet Balance",
          ),
        ),
      );
    } catch (e) {
      debugPrint("Error clearing cart: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Confirm Payment"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.lightBlue.shade300, // light blue
                Colors.blue.shade900, // dark blue
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        // ✅ prevent overflow
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            Center(
              child: Image.network(
                "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fb/Touch_%27n_Go_eWallet_logo.svg/2024px-Touch_%27n_Go_eWallet_logo.svg.png",
                height: 60,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              maskedPhone,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 20),

            Text(
              "RM ${widget.amount.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 40),

            const Text(
              "PIN",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            const Text("Please enter PIN linked to account"),

            const SizedBox(height: 20),

            TextField(
              controller: pinController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              obscureText: true,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                letterSpacing: 16,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                counterText: "",
              ),
              onChanged: (value) {
                if (value.length == 6) {
                  _confirmPin();
                }
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _confirmPin,
              child: const Text("Confirm Payment"),
            ),
          ],
        ),
      ),
    );
  }
}
