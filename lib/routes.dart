// routes.dart
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_gpt/layouts/main_layout.dart';
import 'package:flutter_chat_gpt/screens/order_summary.dart';
import 'package:get/route_manager.dart';

import 'screens/meal_detail_screen.dart';

class RestaurantOrderingRoutes {
  static final routes = [
    GetPage(
        transition: Transition.noTransition,
        name: '/',
        page: () => const MainLayout()),
    GetPage(
        transition: Transition.fadeIn,
        name: '/MealDetailScreen',
        page: () => MealDetailScreen(
              meal: Get.arguments,
            )),
    GetPage(
        transition: Transition.fadeIn,
        name: '/order-summary',
        page: () =>
            //  PaymentScreen()
            const OrderSummary()),
    GetPage(
      transition: Transition.fadeIn,
      name: '/sign-in',
      page: () =>
          //  PaymentScreen()
          SignInScreen(
        actions: [
          AuthStateChangeAction<SignedIn>((context, state) {
            Navigator.pushReplacementNamed(context, '/profile');
          }),
        ],
      ),
    ),
    GetPage(
      transition: Transition.fadeIn,
      name: '/profile',
      page: () =>
          //  PaymentScreen()
          ProfileScreen(
        actions: [
          AuthStateChangeAction<SignedIn>((context, state) {
            Navigator.pushReplacementNamed(context, '/sign-in');
          }),
        ],
      ),
    ),
  ];
}
