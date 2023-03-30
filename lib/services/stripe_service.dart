import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_chat_gpt/models/payment.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class StripeService extends GetxService {
  Map<String, dynamic>? paymentIntent;
  final isLoading = false.obs;

  Future<PaymentStatus> makePayment(double amount, currency) async {
    paymentIntent = await createPaymentIntent(amount, currency);
    //Payment Sheet
    return await stripe.Stripe.instance
        .initPaymentSheet(
            paymentSheetParameters: stripe.SetupPaymentSheetParameters(
                paymentIntentClientSecret: paymentIntent!['client_secret'],
                // applePay: const PaymentSheetApplePay(merchantCountryCode: '+92',),
                // googlePay: const PaymentSheetGooglePay(testEnv: true, currencyCode: "US", merchantCountryCode: "+92"),
                style: ThemeMode.dark,
                merchantDisplayName: 'Chat GPT'))
        .then((_) => displayPaymentSheet())
        .catchError((e, s) {
      dev.log('exception:$e$s');
      return PaymentStatus.failed;
    });
  }

  Future<PaymentStatus> displayPaymentSheet() async {
    isLoading.value = false;
    PaymentStatus status = PaymentStatus.pending;
    await stripe.Stripe.instance.presentPaymentSheet().then((value) {
      paymentIntent = null;
      status = PaymentStatus.success;
    }).catchError((error, stackTrace) {
      dev.log('Error is:--->$error $stackTrace');
      status = PaymentStatus.failed;
    });
    return status;
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(double amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer sk_test_51LksPcLqINE1zk2lwsEqrQQ7EKkbHaN5glS2TZH6OXjzehyfmGWB2HIAAj7IZjA1HmjIZzgtbLmw5YwRU9MmA5NH00yBtcmIW1',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      // ignore: avoid_dev.log
      dev.log('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      // ignore: avoid_dev.log
      dev.log('err charging user: ${err.toString()}');
    }
  }

  String calculateAmount(double amount) {
    //remove de decimal point and replace it with empty string equivalent to *100 then converting to int then to string
    return amount.toStringAsFixed(2).replaceAll(".", "");
  }
}
