import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VendorProfilePage extends StatelessWidget {
  final String vendorEmail; // lookup by email

  const VendorProfilePage({super.key, required this.vendorEmail});

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    // Navigate to login page (replace with your actual login screen route)
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/login', // <-- make sure you have this route defined in MaterialApp
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final vendorStream = FirebaseFirestore.instance
        .collection('vendors')
        .where('email', isEqualTo: vendorEmail)
        .limit(1)
        .snapshots();

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: vendorStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Vendor not found"));
          }

          final vendor = snapshot.data!.docs.first;
          final data = vendor.data() as Map<String, dynamic>;

          final logoUrl = data['logoUrl'] ?? '';
          final name = data['name'] ?? '';
          final email = data['email'] ?? '';
          final phone = data['phone'] ?? '';
          final address = data['address'] ?? '';
          final openTime = data['openTime'] ?? '';
          final closeTime = data['closeTime'] ?? '';
          final openDays = List<String>.from(data['openDays'] ?? []);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile logo
                CircleAvatar(
                  radius: 50,
                  backgroundImage: logoUrl.isNotEmpty
                      ? NetworkImage(logoUrl)
                      : null,
                  child: logoUrl.isEmpty
                      ? const Icon(Icons.store, size: 50)
                      : null,
                ),
                const SizedBox(height: 16),

                // Vendor name
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),
                Text(email, style: const TextStyle(color: Colors.grey)),
                Text(phone, style: const TextStyle(color: Colors.grey)),

                const Divider(height: 32),

                // Address
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(child: Text(address)),
                  ],
                ),
                const SizedBox(height: 16),

                // Open / Close time
                Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text("Open: $openTime - $closeTime"),
                  ],
                ),
                const SizedBox(height: 16),

                // Open Days
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(child: Text("Open Days: ${openDays.join(', ')}")),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.logout),
                    label: const Text("Log Out"),
                    onPressed: () => _logout(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
