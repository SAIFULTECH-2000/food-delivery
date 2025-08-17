import 'package:flutter/material.dart';

/// Helpdesk / Customer Support screen for Food Delivery app
/// Customers can report delivery issues, payment problems, or order mistakes.
class HelpdeskScreen extends StatefulWidget {
  const HelpdeskScreen({super.key});

  @override
  State<HelpdeskScreen> createState() => _HelpdeskScreenState();
}

class _HelpdeskScreenState extends State<HelpdeskScreen> {
  final List<Map<String, dynamic>> tickets = [
    {
      'id': 'ORD-5012',
      'subject': 'Wrong item delivered',
      'status': 'Open',
      'priority': 'High',
      'updated': '2h ago',
    },
    {
      'id': 'ORD-5034',
      'subject': 'Payment deducted but order not placed',
      'status': 'In Progress',
      'priority': 'Medium',
      'updated': '5h ago',
    },
    {
      'id': 'ORD-5041',
      'subject': 'Order delayed by 40 minutes',
      'status': 'Resolved',
      'priority': 'Low',
      'updated': '1d ago',
    },
  ];

  /// Show popup for new ticket
  void _showNewTicketDialog() {
    final subjectController = TextEditingController();
    final descriptionController = TextEditingController();
    String priority = "Medium";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text("New Helpdesk Ticket"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: subjectController,
                  decoration: const InputDecoration(
                    labelText: "Subject",
                    prefixIcon: Icon(Icons.title),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    prefixIcon: Icon(Icons.description),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: priority,
                  decoration: const InputDecoration(
                    labelText: "Priority",
                    prefixIcon: Icon(Icons.flag),
                  ),
                  items: const [
                    DropdownMenuItem(value: "High", child: Text("High")),
                    DropdownMenuItem(value: "Medium", child: Text("Medium")),
                    DropdownMenuItem(value: "Low", child: Text("Low")),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      priority = value;
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (subjectController.text.trim().isNotEmpty) {
                  setState(() {
                    tickets.insert(0, {
                      'id': 'ORD-${5000 + tickets.length + 1}', // simple ID
                      'subject': subjectController.text.trim(),
                      'status': 'Open',
                      'priority': priority,
                      'updated': 'Just now',
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Helpdesk"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showNewTicketDialog,
        icon: const Icon(Icons.add),
        label: const Text("New Ticket"),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: tickets.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final ticket = tickets[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                backgroundColor: Colors.green.shade100,
                child: const Icon(Icons.receipt_long, color: Colors.green),
              ),
              title: Text(
                ticket['subject'],
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text("ID: ${ticket['id']}"),
                  Row(
                    children: [
                      Chip(
                        label: Text(ticket['status']),
                        backgroundColor: Colors.blue.shade50,
                      ),
                      const SizedBox(width: 4),
                      Chip(
                        label: Text(ticket['priority']),
                        backgroundColor: Colors.red.shade50,
                      ),
                    ],
                  ),
                  Text(
                    "Updated ${ticket['updated']}",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
