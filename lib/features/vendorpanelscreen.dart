import 'package:flutter/material.dart';

class VendorPanelScreen extends StatelessWidget {
  const VendorPanelScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Example vendor options
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendor Panel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to add new menu item screen
              },
              icon: const Icon(Icons.add),
              label: const Text('Add New Menu Item'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to manage orders screen
              },
              icon: const Icon(Icons.list_alt),
              label: const Text('Manage Orders'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to analytics screen
              },
              icon: const Icon(Icons.analytics),
              label: const Text('View Analytics'),
            ),
          ],
        ),
      ),
    );
  }
}
