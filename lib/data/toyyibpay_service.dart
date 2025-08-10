import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

Future<String?> createToyyibpayBill({
  required Map<String, dynamic> billData,
  required String apiKey,
  required bool isSandbox,
}) async {
  final String baseUrl = isSandbox ? 'https://dev.toyyibpay.com' : 'https://toyyibpay.com';
  final String createBillApiUrl = '$baseUrl/index.php/api/createBill';

  try {
    final response = await http.post(
      Uri.parse(createBillApiUrl),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'userSecretKey': apiKey, ...billData},
    );

if (response.statusCode == 200) {
  final body = response.body.trim();

  // Check if it's JSON or just a raw error string
  if (body.startsWith('{') || body.startsWith('[')) {
    final decoded = json.decode(body);

    if (decoded is List && decoded.isNotEmpty && decoded[0]['BillCode'] != null) {
      return '$baseUrl/${decoded[0]['BillCode']}';
    } else if (decoded is Map && decoded['BillCode'] != null) {
      return '$baseUrl/${decoded['BillCode']}';
    } else {
      debugPrint('Invalid response: $body');
    }
  } else {
    debugPrint('Non-JSON error from Toyyibpay: $body');
  }
}

  } catch (e) {
    debugPrint('Exception: $e');
  }
  return null;
}
