// lib/views/widgets/greeting_card.dart
import 'package:flutter/material.dart';

class GreetingCard extends StatelessWidget {
  final String greetingMessage;

  const GreetingCard({
    super.key,
    required this.greetingMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Set the width to maximum
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF0D47A1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start, // Center the icon and text vertically
        crossAxisAlignment: CrossAxisAlignment.start, // Center them horizontally
        children: [
          const SizedBox(height: 10.0), // Add spacing between icon and text
          Text(
            greetingMessage,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.normal, // Remove bold effect
            ),
            textAlign: TextAlign.left, // Center the text
          ),
        ],
      ),
    );
  }
}
