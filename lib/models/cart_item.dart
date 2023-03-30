import 'package:flutter_chat_gpt/models/meal.dart';
import 'package:get/get.dart';

class CartItem {
  late final Meal meal;

  int quantity = 0.obs();

  CartItem({
    required this.meal,
    required this.quantity,
  });

  static CartItem fromJson(x) {
    return CartItem(
      meal: Meal.fromJson(x),
      quantity: x['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['meal'] = meal.toJson();
    data['quantity'] = quantity;
    return data;
  }
}
