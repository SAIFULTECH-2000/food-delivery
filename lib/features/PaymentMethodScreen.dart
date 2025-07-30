import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/theme/app_theme.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isEditing = false;
  String? _cardDocId;

  @override
  void initState() {
    super.initState();
    _loadSavedCard();
  }

  Future<void> _loadSavedCard() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('paymentMethods')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        _cardDocId = snapshot.docs.first.id;
        _cardNumberController.text = data['cardNumber'] ?? '';
        _expiryController.text = data['expiry'] ?? '';
        _cvvController.text = data['cvv'] ?? '';
        _nameController.text = data['name'] ?? '';
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Widget _buildCardView() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.blue[800],
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "VISA",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _isEditing = true;
                    });
                  },
                  icon: const Icon(Icons.edit, color: Colors.white),
                  label: const Text(
                    "Edit",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _cardNumberController.text.replaceAllMapped(
                RegExp(r".{4}"),
                (match) => "${match.group(0)} ",
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Exp: ${_expiryController.text}",
                  style: const TextStyle(color: Colors.white),
                ),
                Text("CVV: ***", style: const TextStyle(color: Colors.white)),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _nameController.text,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFormView() {
    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        children: [
          TextFormField(
            controller: _cardNumberController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Card Number",
              prefixIcon: Icon(Icons.credit_card),
              border: OutlineInputBorder(),
            ),
            maxLength: 16,
            validator: (value) {
              if (value == null || value.length != 16) {
                return "Enter a valid 16-digit card number";
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _expiryController,
                  keyboardType: TextInputType.datetime,
                  decoration: const InputDecoration(
                    labelText: "Expiry (MM/YY)",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null ||
                        !RegExp(
                          r'^(0[1-9]|1[0-2])\/?([0-9]{2})$',
                        ).hasMatch(value)) {
                      return "Invalid date";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _cvvController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "CVV",
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 3,
                  validator: (value) {
                    if (value == null || value.length != 3) {
                      return "Enter 3-digit CVV";
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: "Cardholder Name",
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Enter name";
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label: const Text("Save Card"),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              backgroundColor: AppTheme.accentGreen,
            ),
            onPressed: _saveCard,
          ),
        ],
      ),
    );
  }

  Future<void> _saveCard() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final cardData = {
        'cardNumber': _cardNumberController.text,
        'expiry': _expiryController.text,
        'cvv': _cvvController.text,
        'name': _nameController.text,
        'timestamp': FieldValue.serverTimestamp(),
      };

      try {
        if (_cardDocId != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('paymentMethods')
              .doc(_cardDocId)
              .update(cardData);
        } else {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('paymentMethods')
              .add(cardData);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Card saved successfully!')),
          );
          setState(() {
            _isEditing = false;
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving card: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Payment Method")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _isEditing
            ? _buildFormView()
            : Center(
                child: SizedBox(
                  width: 450,
                  height: 280,
                  child: _buildCardView(),
                ),
              ),
      ),
    );
  }
}
