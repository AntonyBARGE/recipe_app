import 'package:flutter/material.dart';
import 'package:recipe_app/app/pages/meals/widgets/meals_header.dart';
import 'package:recipe_app/app/pages/meals/widgets/meals_searchbar.dart';

import '../../models/ingredient.dart';
import '../../models/recipe.dart';

class MealsPage extends StatelessWidget {
  MealsPage({super.key});

  static const routeName = '/home';
  final List<Recipe> recipes = [
    Recipe(
      name: 'Pancake',
      ingredients: [
        Ingredient(name: 'Sugar', quantity: 100, unit: Unit.gram),
        Ingredient(name: 'Flour', quantity: 200, unit: Unit.gram),
        Ingredient(name: 'Milk', quantity: 250, unit: Unit.milliliter),
      ],
      instructions: [
        'Mix the dry ingredients.',
        'Add milk and stir well.',
        'Cook on a hot griddle.',
      ],
    ),
    Recipe(
      name: 'Omelette',
      ingredients: [
        Ingredient(name: 'Egg', quantity: 3, unit: Unit.piece),
        Ingredient(name: 'Salt', quantity: 1, unit: Unit.pinch),
        Ingredient(name: 'Butter', quantity: 1, unit: Unit.tablespoon),
      ],
      instructions: [
        'Beat the eggs.',
        'Melt butter in a pan.',
        'Pour the eggs and cook.',
      ],
    ),
    Recipe(
      name: 'Chocolate Cake',
      ingredients: [
        Ingredient(name: 'Flour', quantity: 200, unit: Unit.gram),
        Ingredient(name: 'Sugar', quantity: 150, unit: Unit.gram),
        Ingredient(name: 'Cocoa powder', quantity: 50, unit: Unit.gram),
      ],
      instructions: [
        'Mix the dry ingredients.',
        'Add wet ingredients and stir.',
        'Bake in the oven at 180°C for 30 minutes.',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            children: [
              const MealsHeader(),
              Expanded(
                child: MealsSearchBar(
                  recipes: recipes,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
