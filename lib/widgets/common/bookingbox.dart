import 'package:flutter/material.dart';
import 'confirmationmodal.dart';

class BookingBox extends StatelessWidget {
  final VoidCallback onConfirm;
  final String label; // Parameter for the label
  final Color color;  // Color of the filled portion
  final bool isEnabled;
  final double occupancy; // Value between 0.0 and 1.0 representing the occupancy percentage
  final bool donebooking;
  const BookingBox({
    super.key,
    required this.onConfirm,
    required this.label,
    required this.color,
    this.isEnabled = true,
    this.occupancy = 0.0, // Default to fully booked
    this.donebooking = false
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? () {
        if(donebooking){
          _showLoginErrorDialog(context,'You are not allowed to book for more than one room');
          return;
        }
        if(1 == occupancy){
           _showLoginErrorDialog(context,'This room has been fully booked');
          return;
        }
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ConfirmationDialog(
              title: 'Confirm Booking',
              content: 'Are you sure you want to book this room?',
              onConfirm: onConfirm,
            );
          },
        );
      } : null,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: Colors.transparent, // Keep the outer container transparent
        ),
        child: Stack(
          children: [
            // Filled portion
            Container(
              width: 50 * occupancy,
              height: 50,
              decoration: BoxDecoration(
                color: color, // Use the color passed to the widget
              ),
            ),
            // Unfilled portion (optional)
            // If you want to indicate the unfilled portion with a different color
            if (occupancy < 1.0)
              Container(
                width: 50 * (1 - occupancy),
                height: 50,
                color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.2), // Light grey to indicate unavailability
              ),
            Center(
              child: Text(
                label, // Display the label text
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10), // Adjust font size as needed
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 void _showLoginErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: const [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 8),
              Text('Booking Failed'),
            ],
          ),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
