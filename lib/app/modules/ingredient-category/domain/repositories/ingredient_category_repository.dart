import '../../../../../core/http/cache_strategy.dart';
import '../entities/ingredient_category_entity.dart';

abstract class IngredientCategoryRepository {
  Future<List<IngredientCategoryEntity>> retrieveIngredientCategories({
    CacheStrategy cacheStrategy = CacheStrategy.networkOrCache,
  });

  Future<IngredientCategoryEntity> createIngredientCategory({
    required IngredientCategoryEntity newCategory,
  });

  Future<IngredientCategoryEntity> updateIngredientCategory({
    required IngredientCategoryEntity updatedCategory,
  });

  Future<void> deleteIngredientCategory({
    required int categoryId,
  });
}
