import 'package:flutter/material.dart';
import 'package:flutter_chat_gpt/models/cart_item.dart';
import 'package:flutter_chat_gpt/services/cart_service.dart';
import 'package:get/get.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

  const CartItemWidget({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CartService());

    return Card(
      // margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Obx(
        () => cartController.cart.value.cartItems.isNotEmpty
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.network(cartItem.meal.imageUrl,
                              fit: BoxFit.cover),
                        )),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cartItem.meal.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text('\$${(cartItem.meal.price).toStringAsFixed(2)} ',
                              style: Theme.of(context).textTheme.labelLarge),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Theme.of(context).colorScheme.onSecondary,
                    width: 120,
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          iconSize: 20,
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.add,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: () {
                            cartController.incrementQuantity(cartItem);
                          },
                        ),
                        SizedBox(
                          height: 20,
                          child: Text('${cartItem.quantity}',
                              style: Theme.of(context).textTheme.labelMedium),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.remove,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                          onPressed: () {
                            cartController.decrementQuantity(cartItem);
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          iconSize: 20,
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: () {
                            cartController.removeFromCart(cartItem);
                          },
                        ),
                        Text(
                          '\$${(cartItem.meal.price * cartItem.quantity).toStringAsFixed(2)}',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Container(
                height: Get.height,
              ),
      ),
    );
  }
}
