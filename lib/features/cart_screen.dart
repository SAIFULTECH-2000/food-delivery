import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/theme/app_theme.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final String apiKey = 'wwex5am2-3fqs-hjjo-6ik8-6qqf412a39nx';
  final String categoryCode = '97t5ryqw';
  final String callbackUrl = 'https://example.com/callback';
  final String redirectUrl = 'https://example.com/redirect';
  final bool isSandbox = true;
  String selectedLanguage = 'EN';
  String selectedLocation = 'Library Building';
  List<Map<String, dynamic>> cartItems = [];
  bool isLoading = true;
  bool hasSufficientBalance = true;
  String selectedMethod = 'pickup';
  String paymentMethod = 'fpx';

  double deliveryFee = 0.0;
  String restaurantName = 'Unknown Restaurant';
  final Map<String, Map<String, String>> localizedStrings = {
    'EN': {'pickupAddress': 'Pickup Address:'},
    'MS': {'pickupAddress': 'Alamat Pengambilan:'},
  };
  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  Future<void> _initAsync() async {
    await fetchCartItems();

    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLanguage = prefs.getString('language') ?? 'EN';
      selectedLocation = prefs.getString('location') ?? 'Library Building';
    });
  }

  Future<void> fetchCartItems() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final cartSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('cart')
        .get();

    setState(() {
      cartItems = cartSnapshot.docs.map((doc) {
        restaurantName = doc['restaurantName'] ?? 'Unknown Restaurant';
        return {
          'id': doc.id,
          'name': doc['name'],
          'price': doc['price'],
          'quantity': doc['quantity'],
          'imageUrl': doc['imageUrl'],
        };
      }).toList();
      isLoading = false;
    });
  }

  void updateDeliveryMethod(String method) {
    setState(() {
      selectedMethod = method;
      deliveryFee = method == 'pickup' ? 0.0 : 5.00;
    });
  }

  void updatePaymentMethod(String method) {
    setState(() {
      paymentMethod = method;
    });
  }

  Future<String?> createToyyibpayBill({
    required Map<String, dynamic> billData,
    required String apiKey,
    bool isSandbox = true,
  }) async {
    final String url = isSandbox
        ? 'https://dev.toyyibpay.com/index.php/api/createBill'
        : 'https://toyyibpay.com/index.php/api/createBill';

    final body = {'userSecretKey': apiKey, ...billData};

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: body,
    );

    if (response.statusCode == 200) {
      try {
        final result = jsonDecode(response.body);
        if (result is List && result[0]['BillCode'] != null) {
          final billCode = result[0]['BillCode'];
          return isSandbox
              ? 'https://dev.toyyibpay.com/$billCode'
              : 'https://toyyibpay.com/$billCode';
        }
        if (result is String && result.startsWith('[KEY-DID-NOT')) {
          throw 'Invalid Toyyibpay API key or user not active.';
        }
        throw 'Unexpected response: $result';
      } catch (e) {
        throw 'Parse error: $e';
      }
    } else {
      throw 'Toyyibpay API error: ${response.statusCode}';
    }
  }

  Future<void> _deleteCartItem(String itemId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .doc(itemId)
          .delete();

      setState(() {
        cartItems.removeWhere((item) => item['id'] == itemId);
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Item removed from cart')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to remove item: $e')));
    }
  }

  Future<void> _initiatePayment(double amount) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) return;

    final name =
        (user.displayName != null && user.displayName!.trim().isNotEmpty)
        ? user.displayName!
        : 'Customer';

    final billData = {
      'categoryCode': categoryCode,
      'billName': 'Food Order',
      'billDescription': 'Payment for food from $restaurantName',
      'billPriceSetting': '1',
      'billPayorInfo': '1',
      'billAmount': (amount * 100).toInt().toString(),
      'billReturnUrl': redirectUrl,
      'billCallbackUrl': callbackUrl,
      'billTo': name,
      'billEmail': user.email!,
      'billPhone': '0123456789',
      'billExternalReferenceNo':
          'order-${DateTime.now().millisecondsSinceEpoch}',
      'billpaymentAmount': (amount * 100).toInt().toString(),
    };

    try {
      final paymentUrl = await createToyyibpayBill(
        billData: billData,
        apiKey: apiKey,
        isSandbox: isSandbox,
      );

      if (paymentUrl != null) {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentWebView(
              paymentUrl: paymentUrl,
              redirectBaseUrl: redirectUrl,
            ),
          ),
        );

        if (result == true) {
          fetchCartItems(); // 🟢 refresh your cart after successful payment
        }
      } else {
        throw 'Cannot open payment URL.';
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Payment error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    double itemTotal = cartItems.fold(
      0.0,
      (sum, item) => sum + (item['price'] * item['quantity']),
    );
    double totalWithDelivery = itemTotal + deliveryFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Order'),
        backgroundColor: AppTheme.accentGreen,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (selectedMethod == 'pickup')
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: Text(
                      localizedStrings[selectedLanguage]?['pickupAddress'] ??
                          'Pickup Address:',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ListTile(
                  leading: const Icon(Icons.storefront, color: Colors.red),
                  title: Text(restaurantName),
                  subtitle: const Text('Pickup Location will be shown here'),
                  trailing: PopupMenuButton<String>(
                    icon: const Icon(Icons.chevron_right),
                    onSelected: updateDeliveryMethod,
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'pickup', child: Text('Pickup Now')),
                      PopupMenuItem(
                        value: 'delivery',
                        child: Text('Order For Later'),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        selectedMethod == 'pickup'
                            ? 'Pickup Now - Ready in 5 minutes'
                            : 'Delivery - Estimated in 30-45 minutes',
                      ),
                    ],
                  ),
                ),
                const Divider(height: 20),

                // Cart Items
                Expanded(
                  child: cartItems.isEmpty
                      ? const Center(child: Text('Your cart is empty.'))
                      : ListView.builder(
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cartItems[index];
                            return Dismissible(
                              key: Key(item['id'] ?? 'unknown-$index'),

                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              onDismissed: (direction) async {
                                await _deleteCartItem(item['id']);
                              },
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    item['imageUrl'],
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        const Icon(Icons.image),
                                  ),
                                ),
                                title: Text(item['name']),
                                subtitle: Text(
                                  'RM ${item['price']} x ${item['quantity']}',
                                ),
                                trailing: Text(
                                  'RM ${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: AppTheme.accentGreen,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),

                // Order Summary
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTotalRow(
                        'Item Total',
                        'RM ${itemTotal.toStringAsFixed(2)}',
                      ),
                      _buildTotalRow(
                        'Delivery Fee',
                        'RM ${deliveryFee.toStringAsFixed(2)}',
                      ),
                      const Divider(),
                      _buildTotalRow(
                        'Grand Total',
                        'RM ${totalWithDelivery.toStringAsFixed(2)}',
                        isBold: true,
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        'Payment Method:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 8),
                          ChoiceChip(
                            label: const Text('FPX (Toyyibpay)'),
                            selected: paymentMethod == 'fpx',
                            onSelected: (_) => updatePaymentMethod('fpx'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _initiatePayment(totalWithDelivery),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentGreen,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            selectedMethod == 'pickup'
                                ? 'Place Pickup Order'
                                : 'Place Delivery Order',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildTotalRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: isBold ? FontWeight.bold : null),
          ),
          Text(
            value,
            style: TextStyle(fontWeight: isBold ? FontWeight.bold : null),
          ),
        ],
      ),
    );
  }
}

// ------------------- Payment WebView -------------------------

class PaymentWebView extends StatefulWidget {
  final String paymentUrl;
  final String redirectBaseUrl; // e.g. "https://example.com/redirect"

  const PaymentWebView({
    super.key,
    required this.paymentUrl,
    required this.redirectBaseUrl,
  });

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController _controller;
  String? lastLoadedUrl;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final url = request.url;
            debugPrint("Navigating to: $url");

            // Handle redirect to our status page
            if (url.startsWith(widget.redirectBaseUrl)) {
              final uri = Uri.parse(url);
              final billcode = uri.queryParameters['billcode'];
              if (billcode != null) {
                final statusUrl = 'https://dev.toyyibpay.com/$billcode';
                lastLoadedUrl = statusUrl;
                _controller.loadRequest(Uri.parse(statusUrl));
                return NavigationDecision.prevent;
              }
            }

            return NavigationDecision.navigate;
          },
          onPageFinished: (url) async {
            debugPrint("Page finished loading: $url");

            if (url == lastLoadedUrl) {
              try {
                final result = await _controller.runJavaScriptReturningResult(
                  "document.querySelector('.wrapper-bill')?.innerText",
                );

                final text = result.toString().toLowerCase();
                debugPrint("Page content: $text");

                if (text.contains("payment successful")) {
                  await _clearUserCart(); // delete from Firestore

                  Future.delayed(const Duration(milliseconds: 300), () {
                    toastification.show(
                      context: context,
                      title: const Text('Payment Successful'),
                      description: const Text('Thank you for your order!'),
                      autoCloseDuration: const Duration(seconds: 3),
                      type: ToastificationType.success,
                      alignment: Alignment.bottomCenter,
                    );
                  });

                  Future.delayed(const Duration(seconds: 3), () {
                    Navigator.pop(context); // or navigate to success page
                  });
                } else if (text.contains("payment failed") ||
                    text.contains("unsuccessful")) {
                  Future.delayed(const Duration(milliseconds: 300), () {
                    toastification.show(
                      context: context,
                      title: const Text('Payment Failed'),
                      description: const Text(
                        'Your transaction was unsuccessful.',
                      ),
                      autoCloseDuration: const Duration(seconds: 3),
                      type: ToastificationType.error,
                      alignment: Alignment.bottomCenter,
                    );
                  });

                  Future.delayed(const Duration(seconds: 3), () {
                    Navigator.pop(context); // or redirect to retry screen
                  });
                }
              } catch (e) {
                debugPrint("Error reading page status: $e");
              }
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Payment')),
      body: WebViewWidget(controller: _controller),
    );
  }

  Future<void> _clearUserCart() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        debugPrint("User not logged in.");
        return;
      }

      final cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart');

      final cartSnapshot = await cartRef.get();

      for (final doc in cartSnapshot.docs) {
        await doc.reference.delete();
      }

      debugPrint("✅ User cart cleared.");
    } catch (e) {
      debugPrint("❌ Failed to clear cart: $e");
    }
  }
}
