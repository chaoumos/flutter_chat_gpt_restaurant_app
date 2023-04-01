import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_chat_gpt/models/payment.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class StripeService extends GetxService {
  Map<String, dynamic>? paymentIntent;
  final isLoading = false.obs;

  Future<PaymentStatus> makePayment(double amount, currency) async {
    isLoading.value = true;
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
          'Authorization': 'Bearer ${Stripe.publishableKey}',
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

  //remove de decimal point and replace it with empty string equivalent to *100 then converting to int then to string
  String calculateAmount(double amount) {
    return amount.toStringAsFixed(2).replaceAll(".", "");
  }
}
