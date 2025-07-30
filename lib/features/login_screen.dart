import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_delivery_app/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toastification/toastification.dart';
import '../widgets/common/customtextfield.dart';
import '../widgets/common/topwaveclipper.dart';
import 'package:food_delivery_app/core/theme/app_theme.dart';
import 'dashboard_screen.dart'; // Import your dashboard screen

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _login() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (userCredential.user?.uid != null) {
        await prefs.setString('uuid', userCredential.user!.uid);
        await saveUserDataInSession(userCredential);
      

        if (!mounted) return;

        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const DashboardScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.2),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
          ),
        );

        Future.delayed(const Duration(milliseconds: 300), () {
          toastification.show(
            context: context,
            title: const Text('Login Successful'),
            description: const Text(
              'Welcome back! Let’s explore some meals.',
            ),
            autoCloseDuration: const Duration(seconds: 3),
            type: ToastificationType.success,
            alignment: Alignment.bottomCenter,
          );
        });
      }
    } catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Login Error'),
          content: const Text('Some details may be wrong'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('OK'),
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
                        AppLocalizations.of(context)!.signIn,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: emailController,
                              labelText:
                                  AppLocalizations.of(context)!.email,
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
                                  )!.enterPasswordError;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _login(),
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
                          AppLocalizations.of(context)!.login,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/forgotPasswordPage',
                              );
                            },
                            child: Text(
                              AppLocalizations.of(context)!.forgotPassword,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: Text(
                              AppLocalizations.of(context)!.registerNow,
                            ),
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
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// -------------------------------
// Reuse your existing helper functions
// -------------------------------

Future<void> saveUserDataInSession(UserCredential userCredential) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (userCredential.user?.uid != null) {
    String uuid = userCredential.user!.uid;
    await prefs.setString('uuid', uuid);

    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uuid)
        .get();

    if (userSnapshot.exists) {
      Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>?;

      if (userData != null) {
        await prefs.setString('fullName', userData['fullName'] ?? '');
        await prefs.setString('email', userData['email'] ?? '');
        await prefs.setString('phone', userData['phone'] ?? '');
        await prefs.setString(
          'profileImageUrl',
          userData['profileImageUrl'] ?? '',
        );
    
        await prefs.setString('username', userData['username'] ?? '');
      }
    }
  }
}

