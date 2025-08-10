import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<Map<String, String>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _generateNotifications();
  }

  void _generateNotifications() {
    final dummyData = [
      'Your order #${_randomId()} has been shipped',
      'New menu items added to your favorite vendor!',
      'Payment successful for order #${_randomId()}',
      'Promo alert! 25% off selected meals',
      'Order #${_randomId()} is out for delivery',
      'Subscription renewed successfully',
      'Thanks for your feedback!',
      'Account settings updated',
      'Your cart was saved for later',
      'Order #${_randomId()} delivered. Enjoy your meal!',
    ];

    for (var message in dummyData) {
      final notification = {
        'message': message,
        'time': DateFormat('MMM d, h:mm a').format(
          DateTime.now().subtract(Duration(minutes: Random().nextInt(600))),
        ),
      };
      _notifications.add(notification);
    }

    // Animate insertions
    Future.delayed(const Duration(milliseconds: 300), () {
      for (int i = 0; i < _notifications.length; i++) {
        Future.delayed(Duration(milliseconds: 100 * i), () {
          _listKey.currentState?.insertItem(i);
        });
      }
    });
  }

  String _randomId() => (1000 + Random().nextInt(9000)).toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: AppTheme.accentGreen,
      ),
      body: AnimatedList(
        key: _listKey,
        initialItemCount: 0,
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index, animation) {
          final item = _notifications[index];

          return SizeTransition(
            sizeFactor: animation,
            child: Dismissible(
              key: ValueKey(item['message']! + item['time']!),
              direction: DismissDirection.horizontal,
              onDismissed: (direction) {
                final removedItem = _notifications.removeAt(index);
                _listKey.currentState!.removeItem(
                  index,
                  (context, animation) => SizeTransition(
                    sizeFactor: animation,
                    child: _buildNotificationCard(removedItem),
                  ),
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Notification dismissed'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              background: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20),
                color: Colors.redAccent,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              secondaryBackground: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                color: Colors.redAccent,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: _buildNotificationCard(item),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, String> item) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      child: ListTile(
        leading: const Icon(Icons.notifications, color: Colors.deepOrange),
        title: Text(item['message']!),
        subtitle: Text(
          item['time']!,
          style: TextStyle(color: Colors.grey[600]),
        ),
      ),
    );
  }
}
