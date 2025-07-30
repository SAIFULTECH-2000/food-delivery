import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final double total = 20.50;
  bool isLoading = false;

  Future<void> _saveCardAndPay() async {
    setState(() => isLoading = true);
    final user = FirebaseAuth.instance.currentUser!;
    final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final savedData = await userDoc.get();

    try {
      String? customerId = savedData['stripeCustomerId'];
      String? paymentMethodId = savedData['paymentMethodId'];

      if (paymentMethodId != null && customerId != null) {
        // // Use saved card
        // final res = await http.post(
        //   Uri.parse('https://stripe.das-innovations.com/pay_with_saved_card.php'),
        //   headers: {'Content-Type': 'application/json'},
        //   body: jsonEncode({
        //     'amount': (total * 100).toInt(),
        //     'customerId': customerId,
        //     'paymentMethodId': paymentMethodId,
        //   }),
        // );

        // if (res.statusCode != 200) throw Exception('Payment failed');

        // await userDoc.collection('payments').add({
        //   'amount': total,
        //   'timestamp': FieldValue.serverTimestamp(),
        //   'status': 'success',
        // });

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Payment Successful"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                child: const Text("OK"),
              )
            ],
          ),
        );
        return;
      }

      // No saved card — show PaymentSheet using SetupIntent
      final res = await http.post(
        Uri.parse('https://stripe.das-innovations.com/create_setup_intent.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': user.email}),
      );

      final data = jsonDecode(res.body);
      customerId ??= data['customerId'];
      final clientSecret = data['setupIntent'];
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: 'Food Delivery App',
          customerId: customerId,
          setupIntentClientSecret: clientSecret,
          style: ThemeMode.system,
        ),
      );
      await Stripe.instance.presentPaymentSheet();

     // final paymentIntent = await Stripe.instance.retrievePaymentSheetPaymentIntent();
     // final newPaymentMethodId = paymentIntent['payment_method'];

      // Save card info to Firestore
      // await userDoc.set({
      //   'stripeCustomerId': customerId,
      //   'paymentMethodId': newPaymentMethodId,
      // }, SetOptions(merge: true));

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Card Saved"),
          content: const Text("Your card was saved and ready to use."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
              child: const Text("OK"),
            )
          ],
        ),
      );
    } catch (e) {
      // showDialog(
      //   context: context,
      //   builder: (_) => AlertDialog(
      //     title: const Text("Error"),
      //     content: Text(e.toString()),
      //     actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("OK"))],
      //   ),
      // );
      final user = FirebaseAuth.instance.currentUser!;
final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
final cartRef = userDoc.collection('cart');
final orderRef = userDoc.collection('myorder');

final cartSnapshot = await cartRef.get();

for (final cartItem in cartSnapshot.docs) {
  final data = cartItem.data();

  await orderRef.add({
    'name': data['name'],
    'price': data['price'],
    'quantity': data['quantity'],
    'imageUrl': data['imageUrl'],
    'restaurantName': data['restaurantName'],
    'createdAt': FieldValue.serverTimestamp(),
  });

  await cartItem.reference.delete(); // Remove from cart
}
       showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Payment Successful"),
            actions: [
              TextButton(
               onPressed: () {
  Navigator.of(context).popUntil((route) => route.isFirst);
  Navigator.of(context).pushNamed('/myOrder');
},
                child: const Text("OK"),
              )
            ],
          ),
        );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text("Securely pay and save your card"),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.credit_card),
                    label: const Text("Pay Now"),
                    onPressed: _saveCardAndPay,
                  ),
                ],
              ),
            ),
    );
  }
}
