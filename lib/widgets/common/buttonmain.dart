// lib/views/widgets/custom_button.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ButtonMain extends StatelessWidget {
  final String label;
  final String blockName;
  final String routeName;

  const ButtonMain({
    super.key,
    required this.label,
    required this.blockName,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: ElevatedButton(
        onPressed: () {
          _handleButtonPress(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  // Async-safe navigation handler
  void _handleButtonPress(BuildContext context) async {
    final navigator = Navigator.of(context); // Capture navigator before await

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_block', blockName);

    navigator.pushNamed(routeName); // Safe to use here
  }
}
