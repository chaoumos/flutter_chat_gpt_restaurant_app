// order.dart

import 'cart.dart';
import 'cart_item.dart';

class RestaurantOrder {
  final String id;
  final DateTime date;
  final double total;
  final List<CartItem> items;

  RestaurantOrder({
    required this.id,
    required this.date,
    required this.total,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['total'] = total;
    data['items'] = items.map((v) => v.toJson()).toList();
    return data;
  }

  factory RestaurantOrder.fromCart(Cart cart, String id, DateTime date) {
    return RestaurantOrder(
      id: id,
      date: date,
      total: cart.totalAmount,
      items: cart.cartItems.toList(),
    );
  }
}
