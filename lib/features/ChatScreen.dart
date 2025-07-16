import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, String>> messages = [];
  final TextEditingController controller = TextEditingController();

  final List<String> faqQuestions = [
    'What is the delivery time?',
    'Can I cancel my order?',
    'What payment methods are accepted?',
  ];

  void sendMessage(String text) {
    setState(() {
      messages.add({'sender': 'User', 'text': text});
      // Simulate AI reply for FAQ
      messages.add({
        'sender': 'AI',
        'text': _getAutoResponse(text),
      });
    });
    controller.clear();
  }

  String _getAutoResponse(String question) {
    switch (question) {
      case 'What is the delivery time?':
        return 'Delivery typically takes 30-45 minutes.';
      case 'Can I cancel my order?':
        return 'Yes, you can cancel within 5 minutes after ordering.';
      case 'What payment methods are accepted?':
        return 'We accept credit cards, e-wallets, and cash on delivery.';
      case 'Suggest me food':
        return 'You might like our Caesar Salad or Grilled Chicken Sandwich.';
      default:
        return 'Thanks for your question! Our team will get back to you.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Support')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUser = message['sender'] == 'User';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.greenAccent : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(message['text'] ?? ''),
                  ),
                );
              },
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: faqQuestions.map((q) {
              return ElevatedButton(
                onPressed: () => sendMessage(q),
                child: Text(q, style: const TextStyle(fontSize: 12)),
              );
            }).toList(),
          ),
          ElevatedButton(
            onPressed: () => sendMessage('Suggest me food'),
            child: const Text('AI: Suggest me food'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(hintText: 'Type a message...'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => sendMessage(controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
