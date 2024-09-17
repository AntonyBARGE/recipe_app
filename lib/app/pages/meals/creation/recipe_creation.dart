import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../models/ingredient.dart';
import '../../../models/ingredient_with_quantity.dart';
import '../../../models/recipe.dart';
import '../../../models/recipe_category.dart';
import '../../../repositories/ingredient_repository.dart';
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
  final ingredientsProvider =
      StateProvider<List<IngredientWithQuantity>>((ref) => []);
  final instructionsProvider = StateProvider<String>((ref) => '');
  final nutritionProvider = StateProvider<String>((ref) => '');
  final selectedCategoriesProvider =
      StateProvider<List<RecipeCategory>>((ref) => []);

  final TextEditingController _ingredientNameController =
      TextEditingController();
  final TextEditingController _ingredientQuantityController =
      TextEditingController();
  Unit _selectedUnit = Unit.gram;

  @override
  Widget build(BuildContext context) {
    final ingredients = ref.watch(ingredientsProvider);

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
              // RecipeTextField(provider: nameProvider, label: 'Recipe Name'),
              // RecipeTextField(
              //     provider: descriptionProvider, label: 'Description'),
              // RecipeTextField(
              //     provider: pictureUrlProvider, label: 'Picture URL'),
              // RecipeTextField(
              //   provider: noteProvider,
              //   label: 'Note',
              //   keyboardType: TextInputType.number,
              // ),
              // RecipeTextField(
              //   provider: prepTimeProvider,
              //   label: 'Prep Time (minutes)',
              //   keyboardType: TextInputType.number,
              // ),
              // RecipeTextField(
              //   provider: cookTimeProvider,
              //   label: 'Cook Time (minutes)',
              //   keyboardType: TextInputType.number,
              // ),
              // RecipeTextField(
              //   provider: totalTimeProvider,
              //   label: 'Total Time (minutes)',
              //   keyboardType: TextInputType.number,
              // ),
              // RecipeTextField(
              //   provider: numberOfPersonsProvider,
              //   label: 'Serves (number of persons)',
              //   keyboardType: TextInputType.number,
              // ),
              const SizedBox(height: 16),

              // Ingredients Section
              const Text('Ingredients',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ListView.builder(
                shrinkWrap: true,
                itemCount: ingredients.length,
                itemBuilder: (context, index) {
                  final ingredient = ingredients[index];
                  return ListTile(
                    title: Text(
                        '${ingredient.quantity} ${ingredient.unit.name} of ${ingredient.ingredient.name}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        ref.read(ingredientsProvider.notifier).state = [
                          for (final i in ingredients)
                            if (i != ingredient) i,
                        ];
                      },
                    ),
                  );
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ingredientNameController,
                      decoration:
                          const InputDecoration(labelText: 'Ingredient Name'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _ingredientQuantityController,
                      decoration: const InputDecoration(labelText: 'Quantity'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  DropdownButton<Unit>(
                    value: _selectedUnit,
                    items: Unit.values.map((Unit unit) {
                      return DropdownMenuItem<Unit>(
                        value: unit,
                        child: Text(unit.name),
                      );
                    }).toList(),
                    onChanged: (Unit? newValue) {
                      setState(() {
                        if (newValue != null) {
                          _selectedUnit = newValue;
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () async {
                      final String name = _ingredientNameController.text.trim();
                      final double quantity = double.tryParse(
                              _ingredientQuantityController.text.trim()) ??
                          0;
                      if (name.isNotEmpty && quantity > 0) {
                        final newIngredient = Ingredient(
                          name: name,
                        );

                        final createdIngredient = await ref
                            .read(ingredientRepositoryProvider.notifier)
                            .addIngredient(newIngredient);
                        final newIngredientWithQuantity =
                            IngredientWithQuantity(
                          ingredient: createdIngredient,
                          quantity: quantity,
                          unit: _selectedUnit,
                        );
                        ref.read(ingredientsProvider.notifier).state = [
                          ...ingredients,
                          newIngredientWithQuantity
                        ];
                        _ingredientNameController.clear();
                        _ingredientQuantityController.clear();
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // RecipeTextField(
              //   provider: instructionsProvider,
              //   label: 'Instructions (comma separated)',
              // ),
              // RecipeTextField(
              //   provider: nutritionProvider,
              //   label: 'Nutrition (e.g., "Calories: 200, Fat: 10g")',
              // ),
              // const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveRecipe,
                child: const Text('Save Ingredient'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveRecipe() async {
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
      final List<IngredientWithQuantity> ingredients =
          ref.read(ingredientsProvider);
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
        categories: [RecipeCategory(name: 'categorie', id: 1)],
        prepTime: prepTime,
        cookTime: cookTime,
        totalTime: totalTime,
        numberOfPersons: numberOfPersons,
        ingredients: ingredients,
        instructions: instructions,
        nutrition: nutrition,
      );
      await ref.read(recipeRepositoryProvider.notifier).addRecipe(newRecipe);
      context.pop();
    }
  }
}
