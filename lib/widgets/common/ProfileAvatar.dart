import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const CircleAvatar(
        radius: 16,
        child: Icon(Icons.person),
      );
    }

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircleAvatar(radius: 16, child: CircularProgressIndicator(strokeWidth: 2));
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const CircleAvatar(
            radius: 16,
            child: Icon(Icons.person),
          );
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final imageUrl = userData['profileImageUrl'] as String?;

        if (imageUrl == null || imageUrl.isEmpty) {
          return const CircleAvatar(
            radius: 16,
            child: Icon(Icons.person),
          );
        }

        return CircleAvatar(
          radius: 16,
          backgroundImage: NetworkImage(imageUrl),
        );
      },
    );
  }
}
