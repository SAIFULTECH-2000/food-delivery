import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_delivery_app/l10n/app_localizations.dart';
import '../widgets/common/customtextfield.dart';
import '../widgets/common/topwaveclipper.dart';
import 'package:food_delivery_app/core/theme/app_theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  Future<void> _resetPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailController.text.trim(),
        );

        if (!mounted) return; // <-- Guard mounted before using context
        _showSuccessDialog(context, 'Password reset email has been sent.');
      } catch (e) {
        if (!mounted) return; // <-- Guard mounted before using context
        _showErrorDialog(context, e.toString());
      }
    }
  }


  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Success'),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 8),
              Text('Error'),
            ],
          ),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
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
                         AppLocalizations.of(context)!.forgotPassword,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: emailController,
                              labelText:  AppLocalizations.of(context)!.enterEmail,
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
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),

                      ElevatedButton(
                        onPressed: () => _resetPassword(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 80,
                            vertical: 15,
                          ),
                        ),
                        child: Text(
  AppLocalizations.of(context)!.resetPassword,
  style: const TextStyle(color: Colors.white),
),

                      ),
                      const SizedBox(height: 10),

                     TextButton(
  onPressed: () {
    Navigator.pushNamed(context, '/login');
  },
  child: Text(
    AppLocalizations.of(context)!.backToLogin,
  ),
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
