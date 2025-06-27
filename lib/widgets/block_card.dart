import 'package:flutter/material.dart';
import 'common/buttonmain.dart';
class BlockCard extends StatelessWidget {
  final String blockName;
  final String imagePath;

  const BlockCard({
    super.key,
    required this.blockName,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[900]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Image on the left
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(imagePath, height: 100, width: 100, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12), // Space between image and text/button

            // Text and button on the right
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    blockName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                  const SizedBox(height: 8),
                  ButtonMain(
                    label: 'LIHAT',
                    blockName: blockName,
                    routeName: '/blockDetail',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
