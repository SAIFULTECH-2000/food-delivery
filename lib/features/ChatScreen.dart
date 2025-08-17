import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery_app/core/theme/app_theme.dart';
import 'package:food_delivery_app/l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, String>> messages = [];
  final TextEditingController controller = TextEditingController();

  Future<void> sendMessage(String userInput) async {
    setState(() {
      messages.add({'sender': 'User', 'text': userInput});
    });

    final foods = await getAllFoods();
    final response = await askGemini(userInput, foods);

    setState(() {
      messages.add({'sender': 'AI', 'text': response});
    });

    controller.clear();
  }

  Future<List<Map<String, dynamic>>> getAllFoods() async {
    final snapshot = await FirebaseFirestore.instance
        .collectionGroup('foods')
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<String> askGemini(
    String question,
    List<Map<String, dynamic>> foods,
  ) async {
    const apiKey =
        'AIzaSyDnhEObt447FIMUNlFjtSpvBaXnj_1sLFU'; // Replace with your Gemini API key
    const url =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey';

    final foodList = foods
        .map((f) => '${f['name']} - ${f['category']} - RM${f['price']}')
        .join('\n');

    final prompt =
        '''
You are Chefie, a friendly AI food assistant who helps customers explore menus and decide what to eat.
Always reply in a conversational tone, like a chef giving recommendations.

Menu:
$foodList

User question: $question
''';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
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
      return 'Sorry, Chefie could not reach the kitchen (AI service).';
    }

    try {
      final data = json.decode(response.body);
      final reply = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
      return reply ?? 'Hmm… Chefie doesn’t have an answer for that.';
    } catch (e) {
      return 'Oops, Chefie dropped the recipe book! Try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.accentGreen, Colors.orangeAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppTheme.accentGreen,
              child: const Icon(
                Icons.smart_toy,
                color: AppTheme.accentRed,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Chefie",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Your AI Food Assistant",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            itemCount: messages.length + 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _botGreeting();
              } else if (index == 1) {
                return _suggestionBox();
              } else {
                final msg = messages[index - 2];
                final isUser = msg['sender'] == 'User';
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: isUser
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    if (!isUser)
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: AppTheme.accentGreen,
                        child: const Icon(
                          Icons.smart_toy,
                          color: AppTheme.accentRed,
                          size: 20,
                        ),
                      ),
                    if (!isUser) const SizedBox(width: 6),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(14),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.deepOrange : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        msg['text'] ?? '',
                        style: TextStyle(
                          fontSize: 15,
                          color: isUser ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
          _inputBar(t),
        ],
      ),
    );
  }

  /// Greeting bubble
  Widget _botGreeting() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppTheme.accentGreen,
            child: const Icon(Icons.smart_toy, color: Colors.red, size: 20),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Hello 👋 I am Chefie, your AI food assistant. Ask me anything about the menu!',
              style: TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  /// Suggestion pills
  Widget _suggestionBox() {
    final suggestions = [
      'What foods are available today?',
      'What is the cheapest item?',
      'Show me drinks only.',
      'Which foods are above RM10?',
      'Other Frequently Asked',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: suggestions
          .map(
            (q) => ActionChip(
              backgroundColor: Colors.greenAccent,
              label: Text(q, style: const TextStyle(color: Colors.white)),
              onPressed: () => sendMessage(q),
            ),
          )
          .toList(),
    );
  }

  /// Bottom input bar
  Widget _inputBar(AppLocalizations t) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: t.askHint,
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.greenAccent,
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
