import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:food_delivery_app/core/theme/theme_notifier.dart';
import 'package:image_picker/image_picker.dart';
import 'package:food_delivery_app/l10n/app_localizations.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/core/theme/app_theme.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  String? selectedLanguage;
  bool isLoading = true;
  String profileImageUrl = '';
  File? _pickedImage;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final data = doc.data();

    if (data != null) {
      fullNameController.text = data['fullName'] ?? '';
      emailController.text = data['email'] ?? '';
      phoneController.text = data['phone'] ?? '';
      selectedLanguage = data['language'];
      profileImageUrl = data['profileImageUrl'] ?? '';
    }

    setState(() => isLoading = false);
  }

  Future<void> _pickAndUploadImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    setState(() {
      _pickedImage = File(pickedFile.path);
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('profile_images')
        .child('${user.uid}.jpg');

    await storageRef.putFile(_pickedImage!);
    final downloadUrl = await storageRef.getDownloadURL();

    setState(() {
      profileImageUrl = downloadUrl;
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({'profileImageUrl': downloadUrl});
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userData = {
      'fullName': fullNameController.text.trim(),
      'email': emailController.text.trim(),
      'phone': phoneController.text.trim(),
      'language': selectedLanguage,
      'profileImageUrl': profileImageUrl,
    };

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set(userData);

    if (selectedLanguage != null) {
      MyApp.setLocale(context, Locale(selectedLanguage!));
    }

    if (!mounted) return;

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.profileUpdated)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).appBarTheme.iconTheme?.color),
          onPressed: () =>
              Navigator.pushReplacementNamed(context, '/dashboard'),
        ),
        title:
            Text(local.editProfile, style: TextStyle(color: Theme.of(context).appBarTheme.titleTextStyle?.color)),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).appBarTheme.iconTheme?.color),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: profileImageUrl.isNotEmpty
                                ? NetworkImage(profileImageUrl)
                                : const AssetImage(
                                        'assets/images/avatar_placeholder.png')
                                    as ImageProvider,
                          ),
                          IconButton(
                            icon: Icon(Icons.camera_alt, color: Theme.of(context).colorScheme.onSurface),
                            onPressed: _pickAndUploadImage,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: fullNameController,
                      decoration:
                          _buildInputDecoration(local.fullName, Icons.person),
                      validator: (value) => value == null || value.isEmpty
                          ? local.enterName
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: emailController,
                      decoration:
                          _buildInputDecoration(local.email, Icons.email),
                      validator: (value) => value == null || value.isEmpty
                          ? local.enterEmail
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: phoneController,
                      decoration:
                          _buildInputDecoration(local.phone, Icons.phone),
                      validator: (value) => value == null || value.isEmpty
                          ? local.enterPhone
                          : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: _buildInputDecoration(
                          local.chooseLanguage, Icons.language),
                      value: selectedLanguage,
                      items: const [
                        DropdownMenuItem(value: 'en', child: Text('English')),
                        DropdownMenuItem(value: 'ms', child: Text('Malay')),
                      ],
                      onChanged: (value) =>
                          setState(() => selectedLanguage = value),
                      validator: (value) => value == null || value.isEmpty
                          ? local.selectLanguage
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Consumer<ThemeNotifier>(
                      builder: (context, notifier, child) => SwitchListTile(
                        title: Text(local.darkMode),
                        value: notifier.darkTheme,
                        onChanged: (val) {
                          notifier.toggleTheme();
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentGreen,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(local.saveChanges),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Theme.of(context).inputDecorationTheme.fillColor,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
    );
  }
}

