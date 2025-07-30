import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/theme/app_theme.dart';
import 'package:food_delivery_app/l10n/app_localizations.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Rewards'),
        backgroundColor: AppTheme.accentGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Points Summary Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: AppTheme.accentGreen.withOpacity(0.9),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Your Points",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "1,250",
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // navigate or open claim logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.accentGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Claim Rewards"),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Reward History Title
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Reward History",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),

            const SizedBox(height: 12),

            // Reward History List
            Expanded(
              child: ListView(
                children: [
                  rewardTile("10% Off Voucher", "Used on July 28, 2025", true),
                  rewardTile("Free Drink", "Claimed on July 25, 2025", false),
                  rewardTile("Birthday Special", "Claimed on July 20, 2025", false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget rewardTile(String title, String date, bool used) {
    return ListTile(
      leading: Icon(
        used ? Icons.check_circle : Icons.card_giftcard,
        color: used ? Colors.grey : AppTheme.accentGreen,
        size: 30,
      ),
      title: Text(title),
      subtitle: Text(date),
      trailing: used
          ? const Text(
              "Used",
              style: TextStyle(color: Colors.grey),
            )
          : const Text(
              "Active",
              style: TextStyle(color: Colors.green),
            ),
    );
  }
}
