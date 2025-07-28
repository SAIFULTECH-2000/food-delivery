import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery_app/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/common/customtextfield.dart';
import '../widgets/common/topwaveclipper.dart';
import 'package:food_delivery_app/core/theme/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _register() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // Capture Navigator and maybe other context-dependent stuff BEFORE async gaps
    final navigator = Navigator.of(context);

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      String uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'username': usernameController.text.trim(),
        'fullName': fullNameController.text.trim(),
        'email': emailController.text.trim(),
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('uuid', uid);
      await prefs.setString('fullName', fullNameController.text.trim());
      await prefs.setString('email', emailController.text.trim());

      // Check mounted here before using context or navigator
      if (!mounted) return;

      navigator.pushNamed('/dashboard');
    } catch (e) {
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text('Error'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.canvasCream,
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ClipPath(
                        clipper: TopWaveClipper(),
                        child: Container(
                          height: 150,
                          color: AppTheme.accentGreen,
                        ),
                      ),
                      Image.asset(
                        'assets/aimst_food_hub_logo.png',
                        height: 150,
                      ),
                      const SizedBox(height: 10),

                      Text(
                        'AIMST Food Hub',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),

                      Text(
                        'REGISTER',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            // Username
                            const SizedBox(height: 10),

                            // Full Name
                            TextFormField(
                              controller: fullNameController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.badge),
                                labelText: AppLocalizations.of(
                                  context,
                                )!.fullNameLabel,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(
                                    context,
                                  )!.fullNameError;
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 10),

                            // Email
                            CustomTextField(
                              controller: emailController,
                              labelText: AppLocalizations.of(
                                context,
                              )!.emailLabel,
                              icon: Icons.email,
                              obscureText: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(
                                    context,
                                  )!.enterEmailError;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),

                            // Password
                            CustomTextField(
                              controller: passwordController,
                              labelText: AppLocalizations.of(
                                context,
                              )!.passwordLabel,
                              icon: Icons.lock,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(
                                    context,
                                  )!.passwordEmptyError;
                                }
                                if (value.length < 6) {
                                  return AppLocalizations.of(
                                    context,
                                  )!.passwordLengthError;
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),

                      ElevatedButton(
                        onPressed: () => _register(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 100,
                            vertical: 15,
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.register,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: const Text('Login Now'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),

                      ClipPath(
                        clipper: BottomWaveClipper(),
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          color: AppTheme.accentGreen,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '© AIMST UNIVERSITY',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.accentGold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 50);
    var firstControlPoint = Offset(size.width / 4, 0);
    var firstEndPoint = Offset(size.width / 2, 30);
    var secondControlPoint = Offset(size.width * 3 / 4, 80);
    var secondEndPoint = Offset(size.width, 50);

    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
