import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  double total = 20.50; // Sample total, you can calculate from cart
  bool isLoading = false;

  Future<void> _makeStripePayment() async {
    setState(() => isLoading = true);
    try {
      // 1. Create PaymentIntent via PHP backend
      final response = await http.post(
        Uri.parse('https://stripe.das-innovations.com/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'amount': (total * 100).toInt(), // cents
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to create payment intent');
      }

      final jsonResponse = jsonDecode(response.body);
      final clientSecret = jsonResponse['clientSecret'];

      // 2. Initialize Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Food Delivery App',
          style: ThemeMode.light,
        ),
      );

      // 3. Present the Payment Sheet
      await Stripe.instance.presentPaymentSheet();

      // 4. Payment successful
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Success"),
          content: const Text("Your payment was successful!"),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } on StripeException catch (e) {
      print("Stripe Error: ${e.error.localizedMessage}");
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Payment Cancelled"),
          content: Text(e.error.localizedMessage ?? 'Something went wrong'),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } catch (e) {
      print("Error: $e");
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Error"),
          content: Text("Something went wrong: $e"),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
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
      appBar: AppBar(title: const Text('Stripe Payment')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Total: RM ${total.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 22)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _makeStripePayment,
                    child: const Text('Pay with Card'),
                  ),
                ],
              ),
            ),
    );
  }
}
