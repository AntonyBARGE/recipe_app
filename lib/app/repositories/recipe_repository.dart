import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/ingredient.dart';
import '../models/recipe.dart';

class RecipeRepository extends StateNotifier<List<Recipe>> {
  RecipeRepository()
      : super([
          Recipe(
            name: 'Pancake',
            description: 'A simple and fluffy pancake recipe.',
            pictureUrl: 'https://example.com/pancake.jpg',
            note: 4.5,
            categories: [],
            prepTime: 10,
            cookTime: 15,
            totalTime: 25,
            numberOfPersons: 4,
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
            nutrition: {
              'Calories': '250 kcal',
              'Protein': '6 g',
              'Carbohydrates': '50 g',
              'Fat': '5 g',
            },
          ),
          Recipe(
            name: 'Omelette',
            description: 'A classic and easy omelette recipe.',
            pictureUrl: 'https://example.com/omelette.jpg',
            note: 4.0,
            categories: [],
            prepTime: 5,
            cookTime: 10,
            totalTime: 15,
            numberOfPersons: 1,
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
            nutrition: {
              'Calories': '200 kcal',
              'Protein': '12 g',
              'Carbohydrates': '1 g',
              'Fat': '18 g',
            },
          ),
          Recipe(
            name: 'Chocolate Cake',
            description: 'A rich and moist chocolate cake.',
            pictureUrl: 'https://example.com/chocolate_cake.jpg',
            note: 4.8,
            categories: [],
            prepTime: 20,
            cookTime: 30,
            totalTime: 50,
            numberOfPersons: 8,
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
            nutrition: {
              'Calories': '300 kcal',
              'Protein': '4 g',
              'Carbohydrates': '40 g',
              'Fat': '15 g',
            },
          ),
        ]);

  void addRecipe(Recipe recipe) {
    state = [...state, recipe];
  }
}

final recipeRepositoryProvider =
    StateNotifierProvider<RecipeRepository, List<Recipe>>((ref) {
  return RecipeRepository();
});
