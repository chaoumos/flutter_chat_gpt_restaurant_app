import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_gpt/services/order_service.dart';
import 'package:get/get.dart';

import '../services/cart_service.dart';
import '../services/user_service.dart';
import '../widgets/adress_widget.dart';

class OrderSummary extends StatefulWidget {
  const OrderSummary({Key? key}) : super(key: key);

  @override
  State<OrderSummary> createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  Map<String, dynamic>? paymentIntent;
  final _orderService = Get.find<OrderService>();
  final _cartService = Get.find<CartService>();
  final _userService = Get.find<UserService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Summary'),
      ),
      body: ListView(
        children: [
          Card(
              child: Obx(
            () => ListTile(
              leading: const Icon(Icons.person),
              title: Text(_userService.authUser.value?.displayName ??
                  " Please add your name"),
              textColor: _userService.authUser.value?.displayName == null
                  ? Colors.red
                  : Theme.of(context).textTheme.labelLarge?.color,
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _userService.showProfileScreenDialog(),
              ),
            ),
          )),
          Card(
              child: Obx(
            () => ListTile(
              leading: const Icon(Icons.phone),
              title: Text(
                  _userService.authUser.value?.phoneNumber ??
                      "Please add your phone number",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: _userService.authUser.value?.phoneNumber == null
                          ? Colors.red
                          : Colors.black)),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => Get.dialog(
                  useSafeArea: true,
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 30, 8, 80),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                      child: const PhoneInputScreen(),
                    ),
                  ),
                ),
              ),
            ),
          )),
          AdressWidget(userService: _userService),
          Card(
            child: ListTile(
              title: const Text('Total'),
              trailing: Text(
                '\$${_cartService.cart.value.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Center(
            child: Obx(() {
              return FilledButton(
                style: ButtonStyle(
                    minimumSize:
                        MaterialStateProperty.all<Size>(const Size(200, 40))),
                child: _orderService.isLoading.value
                    ? const Text('Make Payment')
                    : const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                onPressed: () async {
                  await _orderService.makePayment();
                },
              );
            }),
          )
        ],
      ),
    );
  }
}
