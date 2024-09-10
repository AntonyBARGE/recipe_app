import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/recipe.dart';

class RecipeRepository extends StateNotifier<List<Recipe>> {
  RecipeRepository() : super([]) {
    _initialize();
  }

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<void> _initialize() async {
    await loadRecipes();
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'recipes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE recipes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            description TEXT,
            pictureUrl TEXT,
            note REAL,
            prepTime INTEGER,
            cookTime INTEGER,
            totalTime INTEGER,
            numberOfPersons INTEGER,
            ingredients TEXT,
            instructions TEXT,
            nutrition TEXT
          )
          ''',
        );
      },
    );
  }

  Future<void> loadRecipes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('recipes');
    state = List.generate(maps.length, (i) {
      return Recipe.fromMap(maps[i]);
    });
  }

  Future<void> addRecipe(Recipe recipe) async {
    final db = await database;
    await db.insert('recipes', recipe.toMap());
    state = [...state, recipe.copyWith()];
  }

  Future<void> updateRecipe(Recipe recipe) async {
    final db = await database;
    await db.update(
      'recipes',
      recipe.toMap(),
      where: 'id = ?',
      whereArgs: [recipe.id],
    );
    state = state.map((r) => r.id == recipe.id ? recipe : r).toList();
  }

  Future<void> deleteRecipe(int id) async {
    final db = await database;
    await db.delete('recipes', where: 'id = ?', whereArgs: [id]);
    state = state.where((r) => r.id != id).toList();
  }
}

final recipeRepositoryProvider =
    StateNotifierProvider<RecipeRepository, List<Recipe>>((ref) {
  return RecipeRepository();
});
