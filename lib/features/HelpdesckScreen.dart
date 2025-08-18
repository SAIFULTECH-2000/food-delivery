import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Helpdesk / Customer Support screen for Food Delivery app
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

                  Navigator.pop(context); // close bottom sheet / form

                  // ✅ Show success popup
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: const Text("✅ Success"),
                        content: const Text(
                          "Your ticket has been submitted successfully!",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatScreen2(
                      ticketId: ticket['id'],
                      subject: ticket['subject'],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

/// Chat screen for a specific helpdesk ticket
class ChatScreen2 extends StatefulWidget {
  final String ticketId;
  final String subject;

  const ChatScreen2({super.key, required this.ticketId, required this.subject});

  @override
  State<ChatScreen2> createState() => _ChatScreen2State();
}

class _ChatScreen2State extends State<ChatScreen2> {
  final List<Map<String, String>> messages = [];
  final TextEditingController controller = TextEditingController();

  /// Send message to AI
  Future<void> sendMessage(String userInput) async {
    setState(() {
      messages.add({'sender': 'User', 'text': userInput});
    });

    final response = await askGemini(userInput);

    setState(() {
      messages.add({'sender': 'AI', 'text': response});
    });

    controller.clear();
  }

  /// Ask Gemini for customer service response
  Future<String> askGemini(String question) async {
    const apiKey =
        'AIzaSyDnhEObt447FIMUNlFjtSpvBaXnj_1sLFU'; // Replace with your Gemini API key
    ; // 🔑 Replace with your Gemini API Key
    const url =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey";

    final prompt =
        '''
You are a polite customer support assistant for a food delivery app.  
Always respond kindly, give clear steps, and apologize if needed.  

Ticket ID: ${widget.ticketId}  
Subject: ${widget.subject}  

Customer says: $question
''';

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": prompt},
            ],
          },
        ],
      }),
    );

    if (response.statusCode != 200) {
      return "⚠️ Sorry, our support AI is not available right now.";
    }

    try {
      final data = json.decode(response.body);
      final reply = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
      return reply ?? "Hmm… I don’t have an answer for that yet.";
    } catch (e) {
      return "⚠️ Error processing AI response.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Ticket ${widget.ticketId}"),
            Text(
              widget.subject,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isUser = msg['sender'] == 'User';
                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.deepOrange : Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      msg['text'] ?? "",
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          _inputBar(),
        ],
      ),
    );
  }

  Widget _inputBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: "Type your message...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.deepOrange,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: () {
                  if (controller.text.trim().isNotEmpty) {
                    sendMessage(controller.text.trim());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
