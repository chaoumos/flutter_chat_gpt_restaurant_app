// meal_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_chat_gpt/models/cart_item.dart';
import 'package:flutter_chat_gpt/screens/meal_detail_screen.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../models/meal.dart';
import '../services/cart_service.dart';

class MealItem extends StatelessWidget {
  final Meal meal;

  const MealItem({super.key, required this.meal});

  void selectMeal(BuildContext context) {
    // Navigate to meal detail scree
    // Get.toNamed("MealDetailScreen", arguments: meal);
    // Get.dialog(
    //   Container(
    //       margin: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
    //       height: 800,
    //       padding: EdgeInsets.all(12),
    //       // color: Theme.of(context).primaryColor,
    //       child: MealDetailScreen(meal: meal),
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(24),
    //         color: Theme.of(context).cardColor,
    //       )),
    // );

    Get.bottomSheet(SizedBox(height: 600, child: MealDetailScreen(meal: meal)),
        isScrollControlled: true);
  }

  @override
  Widget build(BuildContext context) {
    final cartService = Get.find<CartService>();
    return InkWell(
      onTap: () => selectMeal(context),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        margin: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Image.network(
                    meal.imageUrl,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox(
                      height: 250,
                      width: double.infinity,
                      child: Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 60,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  child: Container(
                    height: 58,
                    width: 300,
                    color: Colors.black54,
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                    child: Text(
                      meal.name,
                      style: const TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
                Positioned(
                    bottom: 20,
                    left: 10,
                    child: RatingBar.builder(
                      itemSize: 20,
                      initialRating: meal.ratings,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {},
                    )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.add_shopping_cart_outlined),
                        onPressed: () => cartService
                            .addToCart(CartItem(meal: meal, quantity: 1)),
                      ),
                      const SizedBox(width: 6),
                      // Text('add to cart'),
                    ],
                  ),
                  Text('\$${meal.price}',
                      style: Theme.of(context).textTheme.titleSmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
