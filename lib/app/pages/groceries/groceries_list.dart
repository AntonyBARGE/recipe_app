import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../modules/ingredient-category/providers/ingredient_categories_provider.dart';
import '../../modules/ingredient-category/providers/ingredient_categories_state.dart';
import 'category/categories_list.dart';

class GroceriesList extends ConsumerWidget {
  const GroceriesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(ingredientCategoriesNotifierProvider);
    final theme = Theme.of(context).textTheme;

    void addCategory(String newCategoryName) {
      ref
          .read(ingredientCategoriesNotifierProvider.notifier)
          .addIngredientCategory(newCategoryName);
    }

    void reorderCategories(int oldIndex, int newIndex) {
      ref
          .read(ingredientCategoriesNotifierProvider.notifier)
          .reorderIngredientCategories(oldIndex, newIndex);
    }

    void deleteCategory(String id, int position) {
      ref
          .read(ingredientCategoriesNotifierProvider.notifier)
          .deleteIngredientCategory(id, position);
    }

    void editCategory(String id, String newName) {
      ref
          .read(ingredientCategoriesNotifierProvider.notifier)
          .editNameIngredientCategory(id, newName);
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
        reorderCategories: reorderCategories,
        editCategory: editCategory,
        deleteCategory: deleteCategory,
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
