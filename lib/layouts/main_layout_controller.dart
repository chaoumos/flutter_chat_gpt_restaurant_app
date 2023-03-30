import 'package:flutter/material.dart';
import 'package:flutter_chat_gpt/screens/cart_screen.dart';
import 'package:get/get.dart';

import '../screens/meals_screen.dart';
import '../screens/profile_screen.dart';

class MainLayoutController extends GetxService {
  final _selectedIndex = 0.obs;
  final child = Rx<Widget>(MealsScreen());

  int get selectedIndex => _selectedIndex.value;

  @override
  void onInit() {
    // _tabController = TabController(length: 3, vsync: );
    super.onInit();
  }

  set selectedIndex(int index) => _selectedIndex.value = index;

  void onItemTapped(int index) {
    selectedIndex = index;
    switch (selectedIndex) {
      case 0:
        child.value = MealsScreen();
        break;
      case 1:
        child.value = const CartScreen();
        break;
      case 2:
        child.value = ProfileTabScreen();
        // FirebaseUiScreen();
        break;
      default:
        MealsScreen();
    }
    setChild(child.value);
  }

  void setChild(Widget newchild) {
    child.value = newchild;
  }
}
