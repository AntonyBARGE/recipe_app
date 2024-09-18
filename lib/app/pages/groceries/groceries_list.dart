import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../modules/ingredient-category/domain/entities/ingredient_category_entity.dart';
import '../../modules/ingredient-category/providers/ingredient_categories_provider.dart';
import '../../modules/ingredient-category/providers/ingredient_categories_state.dart';
import 'category/categories_list.dart';

class GroceriesList extends ConsumerWidget {
  const GroceriesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(ingredientCategoriesNotifierProvider);
    final theme = Theme.of(context).textTheme;

    void addCategory(String categoryName) {
      ref
          .read(ingredientCategoriesNotifierProvider.notifier)
          .addIngredientCategory(
            IngredientCategoryEntity(
                name: categoryName,
                id: (state as IngredientCategoriesLoaded)
                        .ingredientCategories
                        .length +
                    1),
          );
    }

    if (state is EmptyIngredientCategories) {
      return Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        color: Colors.green,
        child: Text('No categories available', style: theme.bodyLarge),
      );
    }

    if (state is IngredientCategoriesLoading) {
      return Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        color: Colors.red,
        child: const CircularProgressIndicator(),
      );
    }

    if (state is IngredientCategoriesLoaded) {
      return IngredientCategoriesList(
        ingredientCategories: state.ingredientCategories,
        addCategory: addCategory,
      );
    }

    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      color: Colors.yellow,
      child: Text('Unknown state', style: theme.bodyLarge),
    );
  }
}
