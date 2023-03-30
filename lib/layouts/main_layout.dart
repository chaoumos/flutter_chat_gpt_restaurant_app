import 'dart:developer' as dev;

import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_chat_gpt/layouts/main_layout_controller.dart';
import 'package:flutter_chat_gpt/services/cart_service.dart';
import 'package:get/get.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final cartService = Get.put(CartService());
    final c = Get.put(MainLayoutController());

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.print),
          onPressed: () {
            dev.log(cartService.cart.value.toJson().toString(), name: "cart");
          },
        ),
        //temp action on firestore to batch write dummy data with floating button
        // floatingActionButton: FloatingActionButton.extended(
        //   label: Text("temp firestore action"),
        //   icon: const Icon(Icons.add),
        //   onPressed: () async {
        // final firestoreService = Get.put(FirestoreService());
        //     // List<Meal> meals;
        //     // String data = Kdata;
        //     // List<dynamic> decodedData = json.decode(data);
        //     // meals = decodedData.map((meal) => Meal.fromJson(meal)).toList();
        //     // await firestoreService.clearMeals();
        //     // firestoreService.batchWriteMeals(meals);
        //     List<MealCategory> catMeal;
        //     await firestoreService.clearCategories();
        //     catMeal = (json.decode(KdummyCat) as List<dynamic>)
        //         .map((category) => MealCategory.fromJson(category))
        //         .toList();
        //     await firestoreService.batchWriteCategories(catMeal);
        //   },
        // ),
        body: Obx(() => c.child.value),
        bottomNavigationBar: Obx(
          () => NavigationBar(
            animationDuration: const Duration(milliseconds: 500),
            height: 60,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            elevation: 8,
            selectedIndex: c.selectedIndex,
            onDestinationSelected: (value) => c.onItemTapped(value),
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.home),
                label: 'home',
              ),
              NavigationDestination(
                icon: Tab(
                  icon: Obx(
                    () => badges.Badge(
                      badgeStyle: badges.BadgeStyle(
                          shape: badges.BadgeShape.square,
                          borderRadius: BorderRadius.circular(4),
                          badgeColor: Colors.red,
                          padding: const EdgeInsets.all(2.0)),
                      badgeAnimation: const badges.BadgeAnimation.rotation(
                          animationDuration: Duration(milliseconds: 1000)),
                      showBadge: cartService.cart.value.cartItems.isNotEmpty
                          ? true
                          : false,
                      badgeContent: Text(cartService.totalMealCount.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              )),
                      child: const Icon(Icons.shopping_cart),
                    ),
                  ),

                  //  Icon(Icons.shopping_cart)
                ),
                label: 'cart',
              ),
              const NavigationDestination(
                icon: Icon(Icons.person),
                label: 'profile',
              ),
            ],
          ),
        ));
  }
}
