import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

import '../widgets/common/customtextfield.dart';
import '../widgets/common/topwaveclipper.dart';
import 'package:food_delivery_app/core/theme/app_theme.dart';
import 'dashboard_screen.dart';
import 'package:food_delivery_app/l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GoogleSignIn _googleSignIn = GoogleSignIn(); // ✅ use this

  Future<void> _login() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      await saveUserDataInSession(userCredential);

      // Show success toast with a small delay
      Future.delayed(const Duration(milliseconds: 300), () {
        toastification.show(
          context: context,
          title: const Text('Login Successful'),
          description: const Text('Welcome back!'),
          autoCloseDuration: const Duration(seconds: 3),
          type: ToastificationType.success,
          alignment: Alignment.bottomCenter,
        );
      });

      // Wait a bit to let the toast display before navigating
      await Future.delayed(const Duration(seconds: 1));

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const ModernHomeScreen(),
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
    } on FirebaseAuthException catch (e) {
      _showLoginErrorDialog(
        e.message ?? AppLocalizations.of(context)!.unknownErrorOccurred,
      );
    } catch (_) {
      _showLoginErrorDialog(
        AppLocalizations.of(context)!.someDetailsMayBeWrong,
      );
    }
  }

  Future<void> _signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser == null) {
      print('User cancelled the sign-in'); // 👈 Happens if user dismisses it
      return;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
    Future.delayed(const Duration(milliseconds: 300), () {
      toastification.show(
        context: context,
        title: const Text('Login Successful'),
        description: const Text('Welcome back!'),
        autoCloseDuration: const Duration(seconds: 3),
        type: ToastificationType.success,
        alignment: Alignment.bottomCenter,
      );
    });

    // Wait a bit to let the toast display before navigating
    await Future.delayed(const Duration(seconds: 1));

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const ModernHomeScreen(),
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
  }

  void _showLoginErrorDialog(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.loginError),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(AppLocalizations.of(context)!.ok),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  ClipPath(
                    clipper: TopWaveClipper(waveHeight: 80),
                    child: Container(height: 145, color: AppTheme.accentGreen),
                  ),
                  const SizedBox(height: 10),
                  Image.asset('assets/aimst_food_hub_logo.png', height: 100),
                  const SizedBox(height: 10),
                  Text(
                    AppLocalizations.of(context)!.appName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.signIn,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: emailController,
                          labelText: AppLocalizations.of(context)!.email,
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
                        ElevatedButton(
                          onPressed: _login,
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
                        const SizedBox(height: 15),
                        ElevatedButton.icon(
                          onPressed: _signInWithGoogle,
                          icon: Image.asset(
                            'assets/google_icon.jpg',
                            height: 24.0,
                            width: 24.0,
                          ),
                          label: Text(
                            AppLocalizations.of(context)!.signInWithGoogle,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.surface,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.5),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 100,
                              vertical: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/forgotPasswordPage');
                        },
                        child: Text(
                          AppLocalizations.of(context)!.forgotPassword,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Text(AppLocalizations.of(context)!.registerNow),
                      ),
                    ],
                  ),
                  const Spacer(),
                  ClipPath(
                    clipper: BottomWaveClipper(),
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      color: AppTheme.accentGreen,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(
                            context,
                          )!.copyrightAimstUniversity,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.accentGold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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
        await prefs.setString(
          'fullName',
          userData['fullName'] ?? userCredential.user?.displayName ?? '',
        );
        await prefs.setString(
          'email',
          userData['email'] ?? userCredential.user?.email ?? '',
        );
        await prefs.setString('phone', userData['phone'] ?? '');
        await prefs.setString(
          'profileImageUrl',
          userData['profileImageUrl'] ?? userCredential.user?.photoURL ?? '',
        );
        await prefs.setString(
          'username',
          userData['username'] ?? userCredential.user?.displayName ?? '',
        );
      }
    } else {
      await FirebaseFirestore.instance.collection('users').doc(uuid).set({
        'fullName': userCredential.user?.displayName ?? '',
        'email': userCredential.user?.email ?? '',
        'phone': '',
        'profileImageUrl': userCredential.user?.photoURL ?? '',
        'username': userCredential.user?.displayName ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      await prefs.setString('fullName', userCredential.user?.displayName ?? '');
      await prefs.setString('email', userCredential.user?.email ?? '');
      await prefs.setString('phone', '');
      await prefs.setString(
        'profileImageUrl',
        userCredential.user?.photoURL ?? '',
      );
      await prefs.setString('username', userCredential.user?.displayName ?? '');
    }
  }
}
