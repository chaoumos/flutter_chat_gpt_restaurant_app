//meals controller
import 'package:flutter_chat_gpt/models/meal.dart';
import 'package:flutter_chat_gpt/services/firestore_service.dart';
import 'package:get/get.dart';

import '../models/category.dart';

class MealsController extends GetxController {
  final allMeals = <Meal>[].obs;
  final categories = <MealCategory>[].obs;
  final selectedCategory = "All".obs;
  var isLoading = false.obs;
  final firestoreService = Get.find<FirestoreService>();

  @override
  void onInit() {
    isLoading.value = true;
    getallmeal();
    getCategories();
    super.onInit();
  }

  //get all meals from firestore service
  getallmeal() async {
    if (firestoreService.initialized) {
      allMeals.value = await firestoreService.getAllMeals();
    }
    isLoading.value = false;
  }

  //get categoies from firestore service
  getCategories() async {
    final firestoreService = Get.find<FirestoreService>();
    if (firestoreService.initialized) {
      categories.value = await firestoreService.getAllCategories();
    }
    isLoading.value = false;
  }

  selectCategory(MealCategory category) {
    //remove the filter on second click
    if (category.name == selectedCategory.value) {
      selectedCategory.value = "All";

      categories.refresh();
      return;
    }
    selectedCategory.value = category.name;

    categories.refresh();
  }

  //filtred meals by selected category
  List<Meal> get filtredMeals {
    if (selectedCategory.value == "All") {
      return allMeals;
    } else {
      return allMeals
          .where((meal) => meal.category.contains(selectedCategory.value))
          .toList();
    }
  }
}
