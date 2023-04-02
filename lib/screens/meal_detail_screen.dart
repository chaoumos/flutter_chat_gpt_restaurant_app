import 'package:flutter/material.dart';
import 'package:flutter_chat_gpt/models/cart_item.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../models/meal.dart';
import '../services/cart_service.dart';
import 'cart_screen.dart';

class MealDetailScreen extends StatelessWidget {
  final Meal meal;
  const MealDetailScreen({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    var quantity = 1.obs;
    final cartController = Get.put(CartService());
    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: 100,
        backgroundColor: Colors.transparent,
        title: Text(meal.name),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => const CartScreen());
            },
            icon: const Icon(Icons.shopping_cart),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 300,
            width: Get.width,
            child: Stack(
              fit: StackFit.expand,
              alignment: AlignmentDirectional.topCenter,
              children: [
                Image.network(
                  meal.imageUrl,
                  fit: BoxFit.cover,
                  width: Get.width,
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: 50,
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0),
                      ),
                    ),
                    // height: 20,
                    // padding:
                    //     const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Text(
                            '${meal.price} \$',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        RatingBar.builder(
                          itemSize: 20,
                          initialRating: meal.ratings,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {},
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Text(
              meal.category,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Text(
                textAlign: TextAlign.start,
                meal.description,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0),
              ),
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: IconButton(
                      icon: Icon(
                        Icons.remove,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {
                        if (quantity.value > 1) {
                          quantity.value--;
                        }
                      },
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(45),
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    child: Obx(() => Center(
                          child: Text(
                            style: Theme.of(context).textTheme.headlineSmall,
                            '${quantity.value}',
                            textAlign: TextAlign.center,
                          ),
                        )),
                  ),
                  SizedBox(
                    width: 50,
                    height: 50,
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(15),
                    //   color: Colors.grey[200],
                    // ),
                    child: IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {
                        quantity.value++;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FloatingActionButton(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        onPressed: () {
                          // Add the selected meal to the cart with the selected quantity
                          cartController.addToCart(
                              CartItem(meal: meal, quantity: quantity.value));
                          Get.back();
                        },
                        child: Text(
                          'Add to Cart',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                        )),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
