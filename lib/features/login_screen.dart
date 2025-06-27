import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/common/customtextfield.dart';
import '../widgets/common/topwaveclipper.dart';
import 'package:food_delivery_app/core/theme/app_theme.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  LoginScreen({super.key});

  Future<void> _login(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            );

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', emailController.text.trim());

        if (userCredential.user?.uid != null) {
          await prefs.setString('uuid', userCredential.user!.uid);
          await saveUserDataInSession(userCredential);
          await saveBookingData(userCredential.user!.uid);
          Navigator.pushNamed(context, '/dashboard');
        }
      } catch (e) {
        _showLoginErrorDialog(context, 'Some details may be wrong');
      }
    }
  }

  void _showLoginErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 8),
              Text('Login Failed'),
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

                      // App title
                      Text(
                        'AIMST Food Hub',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),

                      // SIGN IN subtitle
                      Text(
                        'SIGN IN',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.all(10), // Add padding here
                        child: Column(
                          children: [
                            // Username TextField
                            TextFormField(
                              controller: usernameController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.person),
                                labelText: 'Username',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your username';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),

                            // Email TextField
                            CustomTextField(
                              controller: emailController,
                              labelText: 'Email',
                              icon: Icons.email,
                              obscureText: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),

                            // Password TextField
                            CustomTextField(
                              controller: passwordController,
                              labelText: 'Password (NDP)',
                              icon: Icons.lock,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),

                      // Log In Button
                      ElevatedButton(
                        onPressed: () => _login(context),
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
                        child: const Text(
                          'Log in',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Forgot password & Register
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
                            child: const Text('Forgot Password'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: const Text('Register Now'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // Bottom wave footer
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

// Bottom Wave Clipper
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

Future<void> saveUserDataInSession(UserCredential userCredential) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Check if the uid is not null and save it
  if (userCredential.user?.uid != null) {
    String uuid = userCredential.user!.uid;
    await prefs.setString('uuid', uuid); // Save UUID

    // Fetch user data from Firestore
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uuid)
        .get();

    if (userSnapshot.exists) {
      Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>?;

      // Save each field from user data in SharedPreferences
      if (userData != null) {
        await prefs.setString('fullName', userData['fullName'] ?? '');
        await prefs.setString('email', userData['email'] ?? '');
        await prefs.setString('phone', userData['phone'] ?? '');
        await prefs.setString('address', userData['address'] ?? '');
        await prefs.setString('course', userData['course'] ?? '');
        await prefs.setString('semester', userData['semester'] ?? '');
        await prefs.setString('familyIncome', userData['familyIncome'] ?? '');
        await prefs.setString('guardianName', userData['guardianName'] ?? '');
        await prefs.setString('guardianPhone', userData['guardianPhone'] ?? '');
        await prefs.setString('healthIssues', userData['healthIssues'] ?? '');
        await prefs.setString('icNumber', userData['icNumber'] ?? '');
        await prefs.setString(
          'profileImageUrl',
          userData['profileImageUrl'] ?? '',
        );
        await prefs.setString('race', userData['race'] ?? '');
        await prefs.setString('religion', userData['religion'] ?? '');
        await prefs.setString(
          'receiptImageUrl',
          userData['receiptImageUrl'] ?? '',
        );
        await prefs.setString('username', userData['username'] ?? '');
      }

      print('User data saved in session.');
    } else {
      print('User data not found.');
    }
  }
}

Future<void> saveBookingData(String userUid) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('bookings')
      .where('userUid', isEqualTo: userUid)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    // Assuming we want to save data from the first document
    var bookingData = querySnapshot.docs[0].data() as Map<String, dynamic>;

    // Save each field in SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('blockName', bookingData['blockName'] ?? '');
    await prefs.setString('level', bookingData['level'] ?? '');
    await prefs.setString('room', bookingData['room'] ?? '');
    await prefs.setString('status', bookingData['status'] ?? '');
  } else {
    print('No bookings found for this user.');
  }
}
