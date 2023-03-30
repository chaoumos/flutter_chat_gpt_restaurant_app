import 'package:flutter/material.dart';
import 'package:flutter_chat_gpt/services/order_service.dart';
import 'package:get/get.dart';

import '../services/cart_service.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Map<String, dynamic>? paymentIntent;
  final _orderService = Get.find<OrderService>();
  final cartService = Get.find<CartService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stripe Payment'),
      ),
      body: Center(
          child: TextButton(
        child: const Text('Make Payment'),
        onPressed: () async {
          await _orderService.makePayment();
        },
      )),
    );
  }
}
