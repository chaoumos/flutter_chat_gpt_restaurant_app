import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_gpt/models/category.dart';
import 'package:get/get.dart';

import '../controllers/meals_controller.dart';
import '../dummy_data.dart';
import '../widgets/meal_item.dart';

List<dynamic> decodedData = json.decode(kdata);

// List<Meal> meals = decodedData.map((meal) => Meal.fromJson(meal)).toList();

class MealsScreen extends StatelessWidget {
  final MealsController mealsController = Get.put(MealsController());

  MealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meals'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: Obx(() => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: mealsController.categories.length,
                  itemBuilder: (context, index) {
                    MealCategory category = mealsController.categories[index];
                    return GestureDetector(
                      onTap: () => mealsController.selectCategory(category),
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: mealsController.selectedCategory.value ==
                                  category.name
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          category.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: mealsController.selectedCategory.value ==
                                    category.name
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    );
                  },
                )),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Obx(() {
              if (mealsController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (mealsController.filtredMeals.isEmpty) {
                return const Center(child: Text('No meals found'));
              } else {
                return ListView.builder(
                  itemCount: mealsController.filtredMeals.length,
                  itemBuilder: (context, index) {
                    final meal = mealsController.filtredMeals[index];
                    return MealItem(meal: meal);
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
