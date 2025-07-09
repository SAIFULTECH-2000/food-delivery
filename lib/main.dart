import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:food_delivery_app/core/theme/app_theme.dart'; // Import your theme
import 'package:food_delivery_app/features/order_detail_screen.dart';
import 'package:food_delivery_app/features/aimst_food_hub_screen.dart';
import 'package:food_delivery_app/features/cart_screen.dart';
import 'package:food_delivery_app/features/dashboard_screen.dart';
import 'package:food_delivery_app/features/login_screen.dart';
import 'package:food_delivery_app/features/menu_screen.dart';
import 'package:food_delivery_app/features/my_order_screen.dart';
import 'package:food_delivery_app/features/payment_screen.dart';
import 'package:food_delivery_app/features/profile_screen.dart';
import 'package:food_delivery_app/features/register_screen.dart';
import 'package:food_delivery_app/l10n/app_localizations.dart'; // Auto-generated

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
      localizationsDelegates: const [
        AppLocalizations.delegate, // Generated delegate
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ms'),
      ],
      theme: AppTheme.lightTheme, // Apply your defined theme here
      initialRoute: '/dashboard',
      routes: {
         '/info': (context) => AimstFoodHubScreen(),
         '/login':(context) => LoginScreen(),
         '/register': (context) => const RegisterScreen(),
         '/dashboard': (context) => const DashboardScreen(),
        '/menu': (context) => const BrowseFoodScreen(),
          '/myOrder': (context) => const MyOrderScreen(),
          '/orderDetail': (context) => OrderDetailScreen(),
          '/cart' : (context) => CartScreen(),
        '/payment': (context) => PaymentScreen(),
        '/profile' : (context) => ProfileScreen(),
        // '/blockDetail': (context) => const BlockDetailScreen(),
        // '/survey': (context) => SurveyPage(),
        // '/profile': (context) => const UserProfileScreen(),
        // '/forgotPasswordPage': (context) => ForgotPasswordPage(),
        // '/notification': (context) => NotificationListScreen(),
      },
    );
  }
}
