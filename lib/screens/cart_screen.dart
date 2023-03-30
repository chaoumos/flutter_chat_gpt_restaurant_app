// cart_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/cart_service.dart';
import '../widgets/cart_item_widget.dart';

//cart_screen.dart

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CartService());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
              child: Obx(
            () => ListView.builder(
              itemBuilder: (ctx, i) {
                return CartItemWidget(
                    cartItem: controller.cart.value.cartItems[i]);
              },
              itemCount: controller.cart.value.cartItems.length,
            ),
          )),
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => Text(
                      'Total ${controller.cart.value.totalAmount.toStringAsFixed(2)} \$',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    child: const Text('ORDER NOW'),
                    onPressed: () {
                      Get.toNamed('/order');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
