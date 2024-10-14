// locator.dart

import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';

import '../../app/modules/ingredient-category/data/backend/cache/ingredient_category_cache_provider.dart';
import '../../app/modules/ingredient-category/data/backend/seed/ingredient_category_seed.dart';
import '../../app/modules/ingredient-category/data/repository/ingredient_category_repository_impl.dart';
import '../../app/modules/ingredient-category/domain/mappers/ingredient_category_mapper.dart';
import '../../app/modules/ingredient-category/domain/repositories/ingredient_category_repository.dart';
import '../../app/modules/ingredient-category/domain/uses_cases/create_ingredient_category.dart';
import '../../app/modules/ingredient-category/domain/uses_cases/delete_ingredient_category.dart';
import '../../app/modules/ingredient-category/domain/uses_cases/retrieve_all_ingredient_category.dart';
import '../../app/modules/ingredient-category/domain/uses_cases/update_ingredient_categories.dart';
import '../../app/modules/ingredient-category/domain/uses_cases/update_ingredient_category.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingletonAsync<Database>(() async {
    final db = await initializeIngredientCategoryDatabase();
    await IngredientCategorySeed.seed(db);
    return db;
  });

  locator.registerLazySingleton(() => IngredientCategoryMapper());
  locator.registerLazySingleton(() => IngredientCategoryCacheProvider());

  locator.registerLazySingleton<IngredientCategoryRepository>(
      () => IngredientCategoryRepositoryImpl());

  locator.registerLazySingleton<RetrieveIngredientCategories>(() =>
      RetrieveIngredientCategories(
          locator.get<IngredientCategoryRepository>()));

  locator.registerLazySingleton<CreateIngredientCategory>(() =>
      CreateIngredientCategory(locator.get<IngredientCategoryRepository>()));

  locator.registerLazySingleton<DeleteIngredientCategory>(() =>
      DeleteIngredientCategory(locator.get<IngredientCategoryRepository>()));

  locator.registerLazySingleton<UpdateIngredientCategories>(() =>
      UpdateIngredientCategories(locator.get<IngredientCategoryRepository>()));

  locator.registerLazySingleton<UpdateIngredientCategory>(() =>
      UpdateIngredientCategory(locator.get<IngredientCategoryRepository>()));
}
