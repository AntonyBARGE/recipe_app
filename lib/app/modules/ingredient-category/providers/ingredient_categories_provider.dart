import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ingredient_categories_notifier.dart';
import 'ingredient_categories_state.dart';

final ingredientCategoriesNotifierProvider = StateNotifierProvider<
    IngredientCategoriesNotifier, IngredientCategoriesState>((ref) {
  return IngredientCategoriesNotifier();
});
