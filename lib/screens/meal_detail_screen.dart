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
            width: double.infinity,
            child: Stack(
              fit: StackFit.loose,
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Image.network(
                  meal.imageUrl,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: 50,
                  width: double.infinity,
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
                            vertical: 10, horizontal: 15),
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
                "rissoler la viande dans le beurre ou la crème à rôtir. Ajouter les oignons, l'ail et tous les légumes, étuver. Incorporer le concentré de tomates, mouiller avec le vin ou la bouillon, laisser mijoter un instant, assaisonner et ajouter les herbes. Laisser mijoter env. 45 min à couvert.",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0),
              ),
              color: Theme.of(context).colorScheme.onInverseSurface,
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
                        onPressed: () {
                          // Add the selected meal to the cart with the selected quantity
                          cartController.addToCart(
                              CartItem(meal: meal, quantity: quantity.value));
                          Get.back();
                        },
                        child: const Text(
                          'Add to Cart',
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



//                 Positioned(
//                   bottom: 20,
//                   right: 10,
//                   child: Container(
//                     width: 300,
//                     color: Colors.black54,
//                     padding:
//                         const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
//                     child: Text(
//                       meal.name,
//                       style: const TextStyle(
//                         fontSize: 26,
//                         color: Colors.white,
//                       ),
//                       softWrap: true,
//                       overflow: TextOverflow.fade,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Row(



        
