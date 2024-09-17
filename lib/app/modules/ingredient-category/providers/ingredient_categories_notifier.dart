import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/app/modules/ingredient-category/domain/entities/ingredient_category_entity.dart';
import 'package:recipe_app/app/modules/ingredient-category/domain/uses_cases/create_ingredient_category.dart';
import 'package:recipe_app/app/modules/ingredient-category/domain/uses_cases/delete_ingredient_category.dart';
import 'package:recipe_app/app/modules/ingredient-category/domain/uses_cases/update_ingredient_category.dart';
import 'package:recipe_app/core/di/locator.dart';

import '../../../../core/clean-archi/clean_archi_base_components.dart';
import '../../../../core/utils/logger.dart';
import '../domain/uses_cases/retrieve_all_ingredient_category.dart';
import 'ingredient_categories_state.dart';

class IngredientCategoriesNotifier
    extends StateNotifier<IngredientCategoriesState> {
  final RetrieveIngredientCategories _retrieveIngredientCategories =
      locator.get();
  final CreateIngredientCategory _createIngredientCategories = locator.get();
  final DeleteIngredientCategory _deleteIngredientCategories = locator.get();
  final UpdateIngredientCategory _updateIngredientCategories = locator.get();

  IngredientCategoriesNotifier() : super(IngredientCategoriesLoading()) {
    fetchIngredientCategories();
  }

  Future<void> fetchIngredientCategories() async {
    state = IngredientCategoriesLoading();
    try {
      final result = await _retrieveIngredientCategories(NoParams());
      print('result: $result');
      if (result.isNotEmpty) {
        state = IngredientCategoriesLoaded(result);
      } else {
        state = EmptyIngredientCategories();
      }
    } catch (e) {
      logger.e("IngredientCategoriesNotifier.fetchIngredientCategories error");
      logger.e(e);
      state = EmptyIngredientCategories();
    }
  }

  Future<void> addIngredientCategory(
      IngredientCategoryEntity ingredientCategory) async {
    List<IngredientCategoryEntity> oldList = [];
    if (state is IngredientCategoriesLoaded) {
      oldList = [...(state as IngredientCategoriesLoaded).ingredientCategories];
    }
    state = IngredientCategoriesLoading();
    try {
      final newIngredient =
          await _createIngredientCategories(ingredientCategory);
      state = IngredientCategoriesLoaded([...oldList, newIngredient]);
    } catch (e) {
      logger.e("IngredientCategoriesNotifier.addIngredientCategory error");
      logger.e(e);
      if (oldList.isEmpty) {
        state = EmptyIngredientCategories();
      } else {
        state = IngredientCategoriesLoaded(oldList);
      }
    }
  }

  Future<void> updateIngredientCategory(
      IngredientCategoryEntity ingredientCategory) async {
    List<IngredientCategoryEntity> oldList = [];
    if (state is IngredientCategoriesLoaded) {
      oldList = [...(state as IngredientCategoriesLoaded).ingredientCategories];
    }
    state = IngredientCategoriesLoading();
    try {
      if (oldList.isEmpty) {
        state = EmptyIngredientCategories();
      } else {
        final updatedIngredient =
            await _updateIngredientCategories(ingredientCategory);
        final index = oldList
            .indexWhere((category) => category.id == updatedIngredient.id);
        if (index != -1) {
          oldList[index] = updatedIngredient;
        }
        state = IngredientCategoriesLoaded([...oldList]);
      }
    } catch (e) {
      logger.e("IngredientCategoriesNotifier.addIngredientCategory error");
      logger.e(e);
      if (oldList.isEmpty) {
        state = EmptyIngredientCategories();
      } else {
        state = IngredientCategoriesLoaded(oldList);
      }
    }
  }

  Future<void> deleteIngredientCategory(int id) async {
    List<IngredientCategoryEntity> oldList = [];
    if (state is IngredientCategoriesLoaded) {
      oldList = [...(state as IngredientCategoriesLoaded).ingredientCategories];
    }
    state = IngredientCategoriesLoading();
    try {
      await _deleteIngredientCategories(id);
      oldList.removeWhere((category) => category.id == id);
      state = oldList.isEmpty
          ? EmptyIngredientCategories()
          : IngredientCategoriesLoaded(oldList);
    } catch (e) {
      logger.e("IngredientCategoriesNotifier.addIngredientCategory error");
      logger.e(e);
      if (oldList.isEmpty) {
        state = EmptyIngredientCategories();
      } else {
        state = IngredientCategoriesLoaded(oldList);
      }
    }
  }
}
