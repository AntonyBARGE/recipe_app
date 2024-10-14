import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../../../core/di/locator.dart';
import '../../../../../../core/errors/exceptions.dart';
import '../../../../../../core/utils/db_constants.dart';
import '../../models/ingredient_category_model.dart';

Future<Database> initializeIngredientCategoryDatabase() async {
  final databasePath = await getDatabasesPath();
  final path =
      join(databasePath, '${DatabaseStore.INGREDIENT_CATEGORY_DATA}.db');

  return openDatabase(
    path,
    onCreate: (db, version) async {
      db.execute(
        '''
        CREATE TABLE ${DatabaseStore.INGREDIENT_CATEGORY_DATA}(
          id TEXT PRIMARY KEY,
          name TEXT,
          position INTEGER
        )
        ''',
      );
    },
    version: 1,
  );
}

class IngredientCategoryCacheProvider {
  final Database _database = locator.get<Database>();

  Future<void> create(IngredientCategoryModel category) async {
    await _database.insert(
      DatabaseStore.INGREDIENT_CATEGORY_DATA,
      category.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<IngredientCategoryModel>> retrieveIngredientCategories() async {
    final List<Map<String, dynamic>> maps =
        await _database.query(DatabaseStore.INGREDIENT_CATEGORY_DATA);
    return List.generate(maps.length, (i) {
      return IngredientCategoryModel.fromJson(maps[i]);
    });
  }

  Future<IngredientCategoryModel> retrieveIngredientCategoryById(int id) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      DatabaseStore.INGREDIENT_CATEGORY_DATA,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return IngredientCategoryModel.fromJson(maps.first);
    }
    throw NotFoundInCacheException();
  }

  Future<void> updateIngredientCategories(
      List<IngredientCategoryModel> categories) async {
    final batch = _database.batch();
    for (var category in categories) {
      batch.update(
        DatabaseStore.INGREDIENT_CATEGORY_DATA,
        category.toJson(),
        where: 'id = ?',
        whereArgs: [category.id],
      );
    }
    await batch.commit(noResult: true);
  }

  Future<void> updateIngredientCategory(
      IngredientCategoryModel category) async {
    await _database.update(
      DatabaseStore.INGREDIENT_CATEGORY_DATA,
      category.toJson(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<void> deleteIngredientCategory(String id) async {
    await _database.delete(
      DatabaseStore.INGREDIENT_CATEGORY_DATA,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
