//cart controller
import 'dart:developer' as dev;

import 'package:flutter_chat_gpt/models/cart.dart';
import 'package:flutter_chat_gpt/models/cart_item.dart';
import 'package:get/get.dart';

class CartService extends GetxService {
  // var cart = Cart(cartItems: RxList<CartItem>([]), totalAmount: 0.0).obs();
  var cart = Rx<Cart>(Cart(cartItems: RxList<CartItem>([]), totalAmount: 0.0));

// initiate the cart
  void init() async {
    cart.value = Cart(cartItems: RxList<CartItem>([]), totalAmount: 0.0);
    dev.log("//initiate the cart");
  }

  //refresh the cart
  void refresh() {
    cart.refresh();
    calculTotalMealCount();
    dev.log("//refresh the cart");
  }

  void addToCart(CartItem cartItem) {
    for (var element in cart.value.cartItems) {
      //check if the item is already in the cart
      if (element.meal.id == cartItem.meal.id) {
        element.quantity += cartItem.quantity;
        refresh();
        return;
      }
    }
    cart.value.cartItems.add(cartItem);
    refresh();
  }

  void removeFromCart(CartItem cartItem) {
    cart.value.cartItems.remove(cartItem);
    Get.snackbar("Cart", "Item removed from cart",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1));
  }

  void clearCart() {
    cart.value.cartItems.clear();
  }

  void decrementQuantity(CartItem item) {
    for (var cartItem in cart.value.cartItems) {
      if (cartItem.meal.id == item.meal.id) {
        cartItem.quantity--;
      }
    }

    if (item.quantity == 0) {
      cart.value.cartItems.remove(item);
      Get.snackbar("Cart", "Item removed from cart",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 1));
    }
    refresh();
  }

  void incrementQuantity(CartItem item) {
    for (var cartItem in cart.value.cartItems) {
      if (cartItem.meal.id == item.meal.id) {
        cartItem.quantity++;
      }
    }
    refresh();
  }

  int _totalMealCount = 0;
  int get totalMealCount => calculTotalMealCount();
  //calculate total meal count in the cart to show on cat icon badge
  int calculTotalMealCount() {
    _totalMealCount = 0;
    for (var element in cart.value.cartItems) {
      _totalMealCount += element.quantity;
    }
    dev.log(_totalMealCount.toString());

    return _totalMealCount;
  }
}
