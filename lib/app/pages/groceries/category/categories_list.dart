import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/app/modules/ingredient-category/providers/ingredient_categories_state.dart';

import '../../../modules/ingredient-category/providers/ingredient_categories_provider.dart';

class IngredientCategoriesList extends ConsumerWidget {
  const IngredientCategoriesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(ingredientCategoriesNotifierProvider);
    print(state);
    final theme = Theme.of(context).textTheme;
    if (state is EmptyIngredientCategories) {
      return Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        color: Colors.green,
      );
    }
    if (state is IngredientCategoriesLoading) {
      return Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        color: Colors.red,
      );
    }
    if (state is IngredientCategoriesLoaded) {
      var ingredientCategories = state.ingredientCategories;
      return ListView.builder(
        itemCount: ingredientCategories.length,
        prototypeItem: ListTile(
          title: Text(ingredientCategories.first.name),
        ),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(ingredientCategories[index].name),
          );
        },
      );
    }
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      color: Colors.yellow,
    );
  }
}
