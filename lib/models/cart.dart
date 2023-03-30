import 'package:get/get_rx/src/rx_types/rx_types.dart';

import 'cart_item.dart';

class Cart {
  RxList<CartItem> cartItems = <CartItem>[].obs;
  double _totalAmount = 0.0;
  double get totalAmount => calculateTotalAmount();

  Cart({required this.cartItems, required double totalAmount}) {
    _totalAmount = calculateTotalAmount();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['items'] = cartItems.map((v) => v).toList();
    data['totalAmount'] = _totalAmount;
    return data;
  }

  factory Cart.fromJson(Map<String, dynamic> json) {
    if (json['items'] == null || json['items'].length == 0) {
      return Cart(cartItems: RxList<CartItem>([]), totalAmount: 0);
    }

    return Cart(
      cartItems:
          RxList<CartItem>.from(json['items'].map((x) => CartItem.fromJson(x))),
      totalAmount: json['totalAmount'],
    );
  }

  double calculateTotalAmount() {
    _totalAmount = 0.0;
    for (var element in cartItems) {
      _totalAmount += element.meal.price * element.quantity;
    }
    return _totalAmount;
  }
}
