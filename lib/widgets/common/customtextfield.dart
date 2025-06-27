import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final bool obscureText;
  final String? Function(String?)? validator; // Add validator parameter

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.icon,
    required this.obscureText,
    this.validator, // Initialize the validator
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField( // Use TextFormField for validation support
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      validator: validator, // Pass the validator to TextFormField
    );
  }
}
