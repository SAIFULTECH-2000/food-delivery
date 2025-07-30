import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/theme/app_theme.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final messageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Help & Support"),
        backgroundColor: AppTheme.accentGreen,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Need Help?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "We’re here to help you! Choose a contact option or send us a message below.",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 20),

            // Contact Options
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.mail_outline, color: Colors.blue),
                    title: const Text("Email Us"),
                    subtitle: const Text("support@aimsthub.com"),
                    onTap: () {
                      // You can integrate mail launcher here
                    },
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(Icons.phone_outlined, color: Colors.green),
                    title: const Text("Call Us"),
                    subtitle: const Text("+60 123-456-789"),
                    onTap: () {
                      // You can integrate phone dialer here
                    },
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(Icons.chat_bubble_outline, color: Colors.orange),
                    title: const Text("Live Chat"),
                    subtitle: const Text("Chat with our support team"),
                    onTap: () {
                      // Future: Navigate to chat page
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Send a Message Form
            const Text(
              "Send us a message",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? "Enter your name" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || !value.contains('@') ? "Enter valid email" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: messageController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: "Message",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? "Enter your message" : null,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Handle send action
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Message sent! We'll get back to you."),
                            ),
                          );
                          nameController.clear();
                          emailController.clear();
                          messageController.clear();
                        }
                      },
                      icon: const Icon(Icons.send),
                      label: const Text("Send Message"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentGreen,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
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
