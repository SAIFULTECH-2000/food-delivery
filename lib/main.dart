import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:food_delivery_app/core/theme/theme_notifier.dart';
import 'package:food_delivery_app/data/uploadVendorsAndMenus.dart';
import 'package:food_delivery_app/features/HelpSupportScreen.dart';
import 'package:food_delivery_app/features/HelpdesckScreen.dart';
import 'package:food_delivery_app/features/PaymentMethodScreen.dart';
import 'package:food_delivery_app/features/RewardsScreen.dart';
import 'package:food_delivery_app/features/SubscriptionScreen.dart';
import 'package:food_delivery_app/features/Vendor/VendorHomePage.dart';
import 'package:food_delivery_app/features/Vendor/vendor_menu_page.dart';
import 'package:food_delivery_app/features/favorite_screen.dart';
import 'package:food_delivery_app/features/forget_password_screen.dart';
import 'package:food_delivery_app/features/specialOfferTinderScreen.dart';
import 'package:food_delivery_app/features/splash_screen.dart';
import 'package:provider/provider.dart';
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
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Load saved language code
  final prefs = await SharedPreferences.getInstance();
  final langCode = prefs.getString('language') ?? 'en';
  // OPTIONAL: Call this only once for seeding
  //await uploadVendorsAndMenus();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: MyApp(startLocale: Locale(langCode)),
    ),
  );
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
    return Consumer<ThemeNotifier>(
      builder: (context, ThemeNotifier themeNotifier, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          title: 'AIMST Food Hub',
          debugShowCheckedModeBanner: false,
          theme: themeNotifier.darkTheme
              ? AppTheme.darkTheme
              : AppTheme.lightTheme,
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
            '/dashboard': (context) => const ModernHomeScreen(),
            '/vendorPage': (context) => const VendorHomePage(),
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
            '/forgotPasswordPage': (context) => const ForgotPasswordScreen(),
            '/SpecialOfferSwiperScreen': (context) =>
                const SpecialOfferSwiperScreen(languageCode: 'langCode'),
            '/FavoriteScreen': (context) => FavoriteScreen(),
            '/helpdeskscreen': (context) => HelpdeskScreen(),
          },
        );
      },
    );
  }
}
