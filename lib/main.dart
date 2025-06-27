import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/theme/app_theme.dart'; // Import your theme
import 'package:food_delivery_app/features/aimst_food_hub_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
    // Initialize notifications and subscribe to notifications
 // await Firebaseapi().initNotification(); // Request notification permissions
  //Firebaseapi().initPushNotification(); // Set up push notification handlers
 // Firebaseapi().subscribeToNotifications(); // Subscribe to Firestore notifications
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // Add the navigator key here
      title: 'AIMST Food Hub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, // Apply your defined theme here
      initialRoute: '/info',
      routes: {
         '/info': (context) => AimstFoodHubScreen(),
        // '/dashboard': (context) => const DashboardScreen(),
        // '/blockDetail': (context) => const BlockDetailScreen(),
        // '/register': (context) => const RegisterScreen(),
        // '/survey': (context) => SurveyPage(),
        // '/profile': (context) => const UserProfileScreen(),
        // '/forgotPasswordPage': (context) => ForgotPasswordPage(),
        // '/notification': (context) => NotificationListScreen(),
      },
    );
  }
}
