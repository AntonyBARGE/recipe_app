import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/app/pages/meals/widgets/recipe_field.dart';

import '../../../models/ingredient.dart';
import '../../../models/recipe.dart';
import '../../../models/recipe_category.dart';
import '../../../repositories/recipe_repository.dart';

class RecipeCreationPage extends ConsumerStatefulWidget {
  const RecipeCreationPage({super.key});
  static const routeName = 'recipe_creation';

  @override
  RecipeCreationPageState createState() => RecipeCreationPageState();
}

class RecipeCreationPageState extends ConsumerState<RecipeCreationPage> {
  final _formKey = GlobalKey<FormState>();

  final nameProvider = StateProvider<String>((ref) => '');
  final descriptionProvider = StateProvider<String>((ref) => '');
  final pictureUrlProvider = StateProvider<String>((ref) => '');
  final noteProvider = StateProvider<String>((ref) => '');
  final prepTimeProvider = StateProvider<String>((ref) => '');
  final cookTimeProvider = StateProvider<String>((ref) => '');
  final totalTimeProvider = StateProvider<String>((ref) => '');
  final numberOfPersonsProvider = StateProvider<String>((ref) => '');
  final ingredientsProvider = StateProvider<String>((ref) => '');
  final instructionsProvider = StateProvider<String>((ref) => '');
  final nutritionProvider = StateProvider<String>((ref) => '');
  final selectedCategoriesProvider =
      StateProvider<List<RecipeCategory>>((ref) => []);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Recipe'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              RecipeTextField(provider: nameProvider, label: 'Recipe Name'),
              RecipeTextField(
                  provider: descriptionProvider, label: 'Description'),
              RecipeTextField(
                  provider: pictureUrlProvider, label: 'Picture URL'),
              RecipeTextField(
                  provider: noteProvider,
                  label: 'Note',
                  keyboardType: TextInputType.number),
              RecipeTextField(
                  provider: prepTimeProvider,
                  label: 'Prep Time (minutes)',
                  keyboardType: TextInputType.number),
              RecipeTextField(
                  provider: cookTimeProvider,
                  label: 'Cook Time (minutes)',
                  keyboardType: TextInputType.number),
              RecipeTextField(
                  provider: totalTimeProvider,
                  label: 'Total Time (minutes)',
                  keyboardType: TextInputType.number),
              RecipeTextField(
                  provider: numberOfPersonsProvider,
                  label: 'Serves (number of persons)',
                  keyboardType: TextInputType.number),
              RecipeTextField(
                  provider: ingredientsProvider,
                  label: 'Ingredients (comma separated)'),
              RecipeTextField(
                  provider: instructionsProvider,
                  label: 'Instructions (comma separated)'),
              RecipeTextField(
                  provider: nutritionProvider,
                  label: 'Nutrition (e.g., "Calories: 200, Fat: 10g")'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveRecipe,
                child: const Text('Save Recipe'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveRecipe() {
    if (_formKey.currentState?.validate() ?? false) {
      final String name = ref.read(nameProvider);
      final String description = ref.read(descriptionProvider);
      final String? pictureUrl = ref.read(pictureUrlProvider).isNotEmpty
          ? ref.read(pictureUrlProvider)
          : null;
      final double? note = ref.read(noteProvider).isNotEmpty
          ? double.parse(ref.read(noteProvider))
          : null;
      final int prepTime = int.parse(ref.read(prepTimeProvider));
      final int cookTime = int.parse(ref.read(cookTimeProvider));
      final int totalTime = int.parse(ref.read(totalTimeProvider));
      final int numberOfPersons = int.parse(ref.read(numberOfPersonsProvider));
      final List<Ingredient> ingredients = ref
          .read(ingredientsProvider)
          .split(',')
          .map((e) => Ingredient(name: e.trim(), quantity: 0, unit: Unit.gram))
          .toList();
      final List<String> instructions = ref
          .read(instructionsProvider)
          .split(',')
          .map((e) => e.trim())
          .toList();
      final Map<String, String>? nutrition =
          ref.read(nutritionProvider).isNotEmpty
              ? Map.fromEntries(
                  ref.read(nutritionProvider).split(',').map((e) {
                    final parts = e.split(':');
                    return MapEntry(parts[0].trim(), parts[1].trim());
                  }),
                )
              : null;

      final newRecipe = Recipe(
        name: name,
        description: description,
        pictureUrl: pictureUrl,
        note: note,
        categories: ref.read(selectedCategoriesProvider),
        prepTime: prepTime,
        cookTime: cookTime,
        totalTime: totalTime,
        numberOfPersons: numberOfPersons,
        ingredients: ingredients,
        instructions: instructions,
        nutrition: nutrition,
      );

      ref.read(recipeRepositoryProvider.notifier).addRecipe(newRecipe);
      context.pop();
    }
  }
}
