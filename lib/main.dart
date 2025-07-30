import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food_delivery_app/data/uploadVendorsAndMenus.dart';
import 'package:food_delivery_app/features/HelpSupportScreen.dart';
import 'package:food_delivery_app/features/PaymentMethodScreen.dart';
import 'package:food_delivery_app/features/RewardsScreen.dart';
import 'package:food_delivery_app/features/SubscriptionScreen.dart';
import 'package:food_delivery_app/features/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'package:food_delivery_app/l10n/app_localizations.dart';
import 'package:food_delivery_app/core/theme/app_theme.dart';

import 'package:food_delivery_app/features/aimst_food_hub_screen.dart';
import 'package:food_delivery_app/features/login_screen.dart';
import 'package:food_delivery_app/features/register_screen.dart';
import 'package:food_delivery_app/features/dashboard_screen.dart';
import 'package:food_delivery_app/features/menu_screen.dart';
import 'package:food_delivery_app/features/my_order_screen.dart';
import 'package:food_delivery_app/features/cart_screen.dart';
import 'package:food_delivery_app/features/payment_screen.dart';
import 'package:food_delivery_app/features/profile_screen.dart';
import 'package:food_delivery_app/features/notifications_screen.dart';
import 'package:food_delivery_app/features/vendorpanelscreen.dart';
import 'package:food_delivery_app/features/feedbackscreen.dart';
import 'package:food_delivery_app/features/EditProfileScreen.dart';
import 'package:food_delivery_app/features/ChatScreen.dart';
import 'package:food_delivery_app/features/VendorsScreen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Stripe
  Stripe.publishableKey = 'pk_test_51RomP8A3vp0NzQfyunn8Qf9YgN271PFnFgQhfL49ZpgehZZsDireO5rQAVSdHDzkjQtYvOLwGxtxVSXXSba38J85000UKWwbO1';
  try {
    await Stripe.instance.applySettings();
  } catch (e) {
    debugPrint('Stripe Init Error: $e');
  }

  // Load saved language code
  final prefs = await SharedPreferences.getInstance();
  final langCode = prefs.getString('language') ?? 'en';
    // OPTIONAL: Call this only once for seeding
 //await uploadVendorsAndMenus();
  runApp(MyApp(startLocale: Locale(langCode)));
}

class MyApp extends StatefulWidget {
  final Locale startLocale;
  const MyApp({super.key, required this.startLocale});

  // Static method to update locale anywhere with context
  static void setLocale(BuildContext context, Locale newLocale) {
    final state = context.findAncestorStateOfType<_MyAppState>();
    state?.changeLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.startLocale;
  }

  void changeLocale(Locale newLocale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', newLocale.languageCode);
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'AIMST Food Hub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: _locale,
      supportedLocales: const [Locale('en'), Locale('ms')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/splash',
      routes: {
        '/info': (context) => AimstFoodHubScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/menu': (context) => const BrowseFoodScreen(),
        '/myOrder': (context) => const MyOrderScreen(),
        '/cart': (context) => CartScreen(),
        '/payment': (context) => PaymentScreen(),
        '/profile': (context) => ProfileScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/vendor': (context) => const VendorPanelScreen(),
        '/feedback': (context) => const FeedbackScreen(),
        '/editProfile': (context) => const EditProfileScreen(),
        '/chat': (context) => const ChatScreen(),
        '/vendors': (context) => const VendorsScreen(),
        '/rewards': (context) => const RewardsScreen(),
        '/subscription': (context) => const SubscriptionScreen(),
        '/support': (context) => const HelpSupportScreen(),
        '/splash': (context) => const SplashScreen(),
        '/paymentMethod': (_) => const PaymentMethodScreen(), // Add this
      },
    );
  }
}
