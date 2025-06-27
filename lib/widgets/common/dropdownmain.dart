// lib/views/widgets/custom_dropdown.dart
import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String? selectedValue;
  final List<String> items;
  final String hint;
  final ValueChanged<String?> onChanged;
  final bool defaultFirst; // New parameter

  const CustomDropdown({
    super.key,
    required this.selectedValue,
    required this.items,
    required this.hint,
    required this.onChanged,
    this.defaultFirst = false, // Default value is false
  });

  @override
  Widget build(BuildContext context) {
    // Set default value if applicable
    final String? currentValue = defaultFirst && selectedValue == null
        ? items.isNotEmpty ? items[0] : null
        : selectedValue;

    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        width: 250,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(15)), // Rounded corners
          border: Border.all(
            color: Colors.grey, // Border color
            width: 1, // Border width
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: currentValue,
            hint: Text(hint),
            icon: const Icon(Icons.arrow_drop_down), // Dropdown arrow
            iconSize: 24,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
            ),
            onChanged: onChanged,
            items: items.map<DropdownMenuItem<String>>((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
