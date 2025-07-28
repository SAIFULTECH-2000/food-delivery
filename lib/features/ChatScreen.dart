import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    final snapshot = await FirebaseFirestore.instance.collectionGroup('foods').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<String> askGemini(String question, List<Map<String, dynamic>> foods) async {
    const apiKey = 'AIzaSyCCXI15-3cxH79zmCcqwfcJC366jlXIMOM'; // Replace with your Gemini API key
    const url =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey';


  final foodList = foods.map((f) {
    return '${f['name']} - ${f['category']} - RM${f['price']}';
  }).join('\n');

  final prompt = '''
You are a helpful food assistant. Based on the menu below, answer the user question.

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
            {"text": prompt}
          ]
        }
      ]
    }),
  );

  // ✅ Check response status
  if (response.statusCode != 200) {
    print('❌ Gemini API failed: ${response.statusCode}');
    print('❌ Response body: ${response.body}');
    return 'Sorry, I could not reach the AI service.';
  }

  // ✅ Check if response body is not empty
  if (response.body.isEmpty) {
    print('❌ Empty response from Gemini API.');
    return 'Sorry, no response from AI.';
  }

  try {
    final data = json.decode(response.body);
    final reply = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
    return reply ?? 'Sorry, I couldn’t find an answer.';
  } catch (e) {
    print('❌ JSON decoding error: $e');
    return 'Sorry, the AI response could not be understood.';
  }
}
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.appTitle)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isUser = msg['sender'] == 'User';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.greenAccent : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(msg['text'] ?? ''),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(hintText: t.askHint),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (controller.text.trim().isNotEmpty) {
                      sendMessage(controller.text.trim());
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
