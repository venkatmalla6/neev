import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

final paymentProvider = Provider<PaymentService>((ref) {
  return PaymentService();
});

class PaymentService {
  late Razorpay _razorpay;

  PaymentService() {
    _razorpay = Razorpay();
  }

  void openCheckout({
    required double amount,
    required String contact,
    required String email,
    required Function(PaymentSuccessResponse) onSuccess,
    required Function(PaymentFailureResponse) onFailure,
    required Function(ExternalWalletResponse) onExternalWallet,
  }) {
    var options = {
      'key': 'YOUR_RAZORPAY_KEY_HERE', // Replace with your active key
      'amount': (amount * 100).toInt(), // amount in the smallest currency unit (paise)
      'name': 'Smart Learning App',
      'description': 'Subject Subscription',
      'prefill': {'contact': contact, 'email': email},
      'external': {
        'wallets': ['paytm']
      }
    };

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, onSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, onFailure);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, onExternalWallet);

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void dispose() {
    _razorpay.clear();
  }
}
