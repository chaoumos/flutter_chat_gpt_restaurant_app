import 'package:flutter/material.dart';
import 'package:flutter_chat_gpt/layouts/main_layout.dart';
import 'package:flutter_chat_gpt/models/cart.dart';
import 'package:flutter_chat_gpt/models/order.dart';
import 'package:flutter_chat_gpt/services/cart_service.dart';
import 'package:flutter_chat_gpt/services/stripe_service.dart';
import 'package:flutter_chat_gpt/services/user_service.dart';
import 'package:get/get.dart';

import '../models/payment.dart';
import 'firestore_service.dart';

class OrderService extends GetxService {
  //TODO :
  //make payment
  //save the payment to database
  //send email to customer
  //save order to database
  // we need to clean the cart and navigate  to order tracking screen

  //import cart service
  //import stripe service
  //import user service
  //import firestore service
  final _firestoreService = Get.find<FirestoreService>();
  final _userService = Get.find<UserService>();
  final _cartService = Get.find<CartService>();
  final _stripeService = Get.find<StripeService>();

  final isLoading = true.obs;
  PaymentStatus paymentResult = PaymentStatus.pending;

  Future<PaymentStatus> makePayment() async {
    isLoading.value = _stripeService.isLoading.value;
    //get the cart
    Cart cart = _cartService.cart.value;

    paymentResult = await _stripeService.makePayment(cart.totalAmount, "usd");

    showDialogSuccess(paymentResult);

    if (paymentResult == PaymentStatus.success) {
      //save the payment to database
      //send email to customer
      //save order to database
      // we need to clean the cart and navigate  to order tracking screen
      await _firestoreService.savePayment(
        Payment(
            amount: cart.totalAmount,
            customerId: _userService.user.value!.id,
            id: _firestoreService.getUID(),
            paymentDate: DateTime.now(),
            paymentMethod: 'stripe'),
      );

      await _firestoreService.saveOrder(RestaurantOrder(
          id: _firestoreService.getUID(),
          date: DateTime.now(),
          items: cart.cartItems,
          total: cart.totalAmount));

      _cartService.clearCart();
      Get.to(() => const MainLayout());
    }
    return paymentResult;
  }

  void showDialogSuccess(PaymentStatus paymentStatus) {
    Get.dialog(
      useSafeArea: true,
      Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(8),
            height: 250,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: paymentStatus == PaymentStatus.success
                  ? <Widget>[
                      const Icon(Icons.check_circle,
                          color: Colors.green, size: 38),
                      Text(
                        'Payment Successfull',
                        style: Theme.of(Get.context!).textTheme.headlineSmall,
                      ),
                      Text(
                        'Thank you for shopping with us. Your order will be delivered soon',
                        style: Theme.of(Get.context!).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      )
                    ]
                  : <Widget>[
                      const Icon(Icons.error, color: Colors.red, size: 38),
                      Text(
                        'Payment Failed',
                        style: Theme.of(Get.context!).textTheme.headlineSmall,
                      ),
                      Text(
                        'Please try again',
                        style: Theme.of(Get.context!).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      )
                    ],
            ),
          ),
        ),
      ),
    );
  }
}
