import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/ingredient.dart';
import '../modules/ingredient-category/domain/entities/ingredient_category_entity.dart';

class IngredientRepository extends StateNotifier<List<Ingredient>> {
  IngredientRepository() : super([]) {
    _initialize();
  }

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'ingredients.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE ingredients (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            pictureUrl TEXT,
            categoryId INTEGER
          )
          ''',
        );
      },
    );
  }

  Future<void> _initialize() async {
    final ingredients = await loadIngredientsFromDb();
    state = ingredients;
  }

  Future<List<Ingredient>> loadIngredientsFromDb() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('ingredients');

    return Future.wait(maps.map<Future<Ingredient>>((map) async {
      final int? categoryId = map['categoryId'] as int?;
      final IngredientCategoryEntity? category =
          categoryId != null ? await getCategoryById(categoryId) : null;

      return Ingredient.fromMap({
        ...map,
        'category': category,
      });
    }).toList());
  }

  Future<IngredientCategoryEntity?> getCategoryById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'ingredient_categories',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return null;
    } else {
      return null;
    }
  }

  Future<Ingredient> addIngredient(Ingredient ingredient) async {
    final id = await _persistIngredient(ingredient);
    final newIngredient = ingredient.copyWith(id: id);
    state = [...state, newIngredient];
    return newIngredient;
  }

  void updateIngredient(Ingredient updatedIngredient) {
    state = state.map((ingredient) {
      return ingredient.id == updatedIngredient.id
          ? updatedIngredient
          : ingredient;
    }).toList();
    _persistIngredient(updatedIngredient);
  }

  void deleteIngredient(int id) {
    state = state.where((ingredient) => ingredient.id != id).toList();
    _deleteIngredientFromDb(id);
  }

  Future<int> _persistIngredient(Ingredient ingredient) async {
    final db = await database;
    final ingredientMap = {
      ...ingredient.toMap(),
      'categoryId': ingredient.category?.id,
    };

    if (ingredient.id == null) {
      return await db.insert('ingredients', ingredientMap);
    } else {
      await db.update('ingredients', ingredientMap,
          where: 'id = ?', whereArgs: [ingredient.id]);
      return ingredient.id!;
    }
  }

  Future<void> _deleteIngredientFromDb(int id) async {
    final db = await database;
    await db.delete('ingredients', where: 'id = ?', whereArgs: [id]);
  }
}

final ingredientRepositoryProvider =
    StateNotifierProvider<IngredientRepository, List<Ingredient>>((ref) {
  return IngredientRepository();
});
