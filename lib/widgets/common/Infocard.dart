import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final List<Map<String, String>> statuses;

  const MyCard({super.key, required this.statuses});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.purple, // Card color
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: SizedBox(
        width: 250,
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: statuses.map((status) {
            return _buildStatusRow(status['label']!, status['status']!);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, String status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between the two children
      children: [
        // Status Box
        Container(
          margin: const EdgeInsets.all(10),
          width: 30, // Change this to a suitable width
          height: 30,
          color: _getStatusColor(status), // Get color based on status
          alignment: Alignment.center,
        ),
        const SizedBox(width: 10), // Space between status box and text
        Expanded(
          // Allows the text to take up remaining space
          child: Text(
            label,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.left, // Aligns text to the left
          ),
        ),
      ],
    );
  }

  // Function to get box color based on status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'available':
        return Colors.white; // White for available
      case 'pending':
        return Colors.yellow; // Yellow for pending
      case 'booking':
        return Colors.red; // Red for booking
      case 'not available':
        return Colors.grey; // Grey for not available
      default:
        return Colors.transparent; // Fallback color
    }
  }
}
