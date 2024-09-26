import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/app/modules/ingredient-category/domain/entities/ingredient_category_entity.dart';
import 'package:recipe_app/app/modules/ingredient-category/domain/uses_cases/create_ingredient_category.dart';
import 'package:recipe_app/app/modules/ingredient-category/domain/uses_cases/delete_ingredient_category.dart';
import 'package:recipe_app/app/modules/ingredient-category/domain/uses_cases/update_ingredient_categories.dart';
import 'package:recipe_app/core/di/locator.dart';
import 'package:uuid/uuid.dart';

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
  final UpdateIngredientCategories _updateIngredientCategories = locator.get();

  IngredientCategoriesNotifier() : super(IngredientCategoriesLoading()) {
    fetchIngredientCategories();
  }

  Future<void> fetchIngredientCategories() async {
    state = IngredientCategoriesLoading();
    try {
      final result = await _retrieveIngredientCategories(NoParams());
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

  Future<void> addIngredientCategory(String newCategoryName) async {
    List<IngredientCategoryEntity> oldList = [];
    if (state is IngredientCategoriesLoaded) {
      oldList = [...(state as IngredientCategoriesLoaded).ingredientCategories];
    }
    state = IngredientCategoriesLoading();
    try {
      if (newCategoryName.isNotEmpty) {
        const uuid = Uuid();
        final newCategory = IngredientCategoryEntity(
          id: uuid.v1(),
          name: newCategoryName,
          position: oldList.length + 1,
        );
        final newIngredientCategory =
            await _createIngredientCategories(newCategory);
        state = IngredientCategoriesLoaded([...oldList, newIngredientCategory]);
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

  Future<void> updateIngredientCategories(
      List<IngredientCategoryEntity> ingredientCategories) async {
    List<IngredientCategoryEntity> oldList = [];
    if (state is IngredientCategoriesLoaded) {
      oldList = [...(state as IngredientCategoriesLoaded).ingredientCategories];
    }
    state = IngredientCategoriesLoading();
    try {
      if (oldList.isEmpty) {
        state = EmptyIngredientCategories();
      } else {
        final Map<String, int> idToIndex = {
          for (var i = 0; i < oldList.length; i++) oldList[i].id: i
        };
        for (var updatedCategory in ingredientCategories) {
          final index = idToIndex[updatedCategory.id];
          if (index != null) {
            oldList[index] = updatedCategory;
          }
        }
        state = IngredientCategoriesLoaded([...oldList]);
        await _updateIngredientCategories(ingredientCategories);
      }
    } catch (e) {
      logger.e("IngredientCategoriesNotifier.updateIngredientCategories error");
      logger.e(e);
      if (oldList.isEmpty) {
        state = EmptyIngredientCategories();
      } else {
        state = IngredientCategoriesLoaded(oldList);
      }
    }
  }

  Future<void> deleteIngredientCategory(String id) async {
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

  Future<void> reorderIngredientCategories(int oldIndex, int newIndex) async {
    List<IngredientCategoryEntity> oldList = [];
    if (state is IngredientCategoriesLoaded) {
      oldList = [...(state as IngredientCategoriesLoaded).ingredientCategories];
    }
    if (oldList.isEmpty) {
      state = EmptyIngredientCategories();
      return;
    }
    oldList.sort((a, b) => a.position.compareTo(b.position));

    try {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }

      final movedCategory = oldList.removeAt(oldIndex);
      oldList.insert(newIndex, movedCategory);

      for (int i = 0; i < oldList.length; i++) {
        oldList[i] = oldList[i].copyWith(position: i + 1);
      }
      await updateIngredientCategories(oldList);
    } catch (e) {
      logger.e("IngredientCategoriesNotifier.updateIngredientCategories error");
      logger.e(e);
      state = IngredientCategoriesLoaded(oldList);
    }
  }
}
