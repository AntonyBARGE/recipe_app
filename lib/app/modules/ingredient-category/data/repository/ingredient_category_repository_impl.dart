import '../../../../../core/clean-archi/clean_archi_base_components.dart';
import '../../../../../core/di/locator.dart';
import '../../../../../core/http/cache_strategy.dart';
import '../../../../../core/utils/logger.dart';
import '../../domain/entities/ingredient_category_entity.dart';
import '../../domain/mappers/ingredient_category_mapper.dart';
import '../../domain/repositories/ingredient_category_repository.dart';
import '../backend/cache/ingredient_category_cache_provider.dart';
import '../models/ingredient_category_model.dart';

class IngredientCategoryRepositoryImpl implements IngredientCategoryRepository {
  final IngredientCategoryMapper _ingredientCategoryMapper = locator.get();
  // final IngredientCategoryRemoteProvider _ingredientcategoryRemoteProvider =
  //     locator.get();
  final IngredientCategoryCacheProvider _ingredientCategoryCacheProvider =
      locator.get();

  @override
  Future<List<IngredientCategoryEntity>> retrieveIngredientCategories({
    CacheStrategy cacheStrategy = CacheStrategy.cacheOnly,
  }) async {
    List<IngredientCategoryModel> dataFromApi = [];

    if (cacheStrategy == CacheStrategy.cacheOnly) {
      dataFromApi =
          await _ingredientCategoryCacheProvider.retrieveIngredientCategories();
    } else if (cacheStrategy == CacheStrategy.networkOnly) {
      // dataFromApi =
      //     await _ingredientcategoryRemoteProvider.retrieveIngredientCategories();
    } else if (cacheStrategy == CacheStrategy.cacheOrNetwork) {
      try {
        dataFromApi = await _ingredientCategoryCacheProvider
            .retrieveIngredientCategories();
      } catch (e) {
        // dataFromApi = await _ingredientcategoryRemoteProvider
        //     .retrieveIngredientCategories();
        // await _ingredientcategoryCacheProvider.store(dataFromApi);
      }
    } else {
      try {
        // dataFromApi = await _ingredientcategoryRemoteProvider
        //     .retrieveIngredientCategories();
        // await _ingredientcategoryCacheProvider.store(dataFromApi);
      } catch (e) {
        logger.e(
            "IngredientCategoryRepositoryImpl.retrieveIngredientCategories Network error");
        logger.e(e);
        dataFromApi = await _ingredientCategoryCacheProvider
            .retrieveIngredientCategories();
      }
    }

    List<IngredientCategoryEntity> entitiesFromData = [];
    for (var ingredientcategoryModel in dataFromApi) {
      Map<BaseModel, Populator> mapperEntry = {};
      mapperEntry[ingredientcategoryModel] = IngredientCategoryModelPopulator();
      entitiesFromData
          .add(_ingredientCategoryMapper.mapModelsToEntity(mapperEntry));
    }

    return entitiesFromData;
  }

  @override
  Future<IngredientCategoryEntity> createIngredientCategory({
    required IngredientCategoryEntity newCategory,
  }) async {
    try {
      final IngredientCategoryModel newCategoryModel =
          _ingredientCategoryMapper.mapEntityToModel(newCategory);

      await _ingredientCategoryCacheProvider.create(newCategoryModel);

      return newCategory;
    } catch (e) {
      logger.e("Error creating ingredient category: $e");
      rethrow;
    }
  }

  @override
  Future<List<IngredientCategoryEntity>> updateIngredientCategories({
    required List<IngredientCategoryEntity> updatedCategories,
  }) async {
    try {
      List<IngredientCategoryModel> updatedCategoryModels = [];
      for (var category in updatedCategories) {
        updatedCategoryModels
            .add(_ingredientCategoryMapper.mapEntityToModel(category));
      }
      await _ingredientCategoryCacheProvider
          .updateIngredientCategories(updatedCategoryModels);
      return updatedCategories;
    } catch (e) {
      logger.e("Error updating ingredient category: $e");
      rethrow;
    }
  }

  @override
  Future<void> deleteIngredientCategory({
    required String categoryId,
  }) async {
    try {
      await _ingredientCategoryCacheProvider
          .deleteIngredientCategory(categoryId);
    } catch (e) {
      logger.e("Error deleting ingredient category: $e");
      rethrow;
    }
  }
}
