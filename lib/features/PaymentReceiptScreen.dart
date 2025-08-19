import 'package:flutter/material.dart';
import 'package:food_delivery_app/features/dashboard_Screen.dart';

class PaymentReceiptScreen extends StatelessWidget {
  final double amount;
  final String receiver;
  final String referenceNo;
  final DateTime dateTime;
  final String method;

  const PaymentReceiptScreen({
    super.key,
    required this.amount,
    required this.receiver,
    required this.referenceNo,
    required this.dateTime,
    required this.method,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 60),

            // Amount
            Text(
              "RM ${amount.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Paid",
              style: TextStyle(fontSize: 18, color: Colors.green),
            ),

            const SizedBox(height: 30),

            // Receiver
            _infoRow("Receiver", receiver),

            const SizedBox(height: 12),

            // Date & Time
            _infoRow(
              "Date & Time",
              "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}",
            ),

            const SizedBox(height: 12),

            // Reference number
            _infoRow("eWallet Reference No.", referenceNo),

            const SizedBox(height: 12),

            // Payment method
            _infoRow("Payment Method", method),

            const Spacer(),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ModernHomeScreen(),
                  ),
                  (route) => false,
                );
              },
              child: const Text("Done"),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
