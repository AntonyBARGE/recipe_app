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

  Future<void> _initialize() async {
    final recipes = await loadRecipesFromDb();
    state = recipes;
  }

  Future<List<Recipe>> loadRecipesFromDb() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('recipes');
    return List.generate(maps.length, (i) => Recipe.fromMap(maps[i]));
  }

  Future<Recipe> addRecipe(Recipe recipe) async {
    final id = await _persistRecipe(recipe);
    final newRecipe = recipe.copyWith(id: id);
    state = [...state, newRecipe];
    return newRecipe;
  }

  void updateRecipe(Recipe updatedRecipe) {
    state = state
        .map((recipe) => recipe.id == updatedRecipe.id ? updatedRecipe : recipe)
        .toList();
    _persistRecipe(updatedRecipe);
  }

  void deleteRecipe(int id) {
    state = state.where((recipe) => recipe.id != id).toList();
    _deleteRecipeFromDb(id);
  }

  Future<int> _persistRecipe(Recipe recipe) async {
    final db = await database;
    if (recipe.id == null) {
      return await db.insert('recipes', recipe.toMap());
    } else {
      await db.update('recipes', recipe.toMap(),
          where: 'id = ?', whereArgs: [recipe.id]);
      return recipe.id!;
    }
  }

  Future<void> _deleteRecipeFromDb(int id) async {
    final db = await database;
    await db.delete('recipes', where: 'id = ?', whereArgs: [id]);
  }
}

final recipeRepositoryProvider =
    StateNotifierProvider<RecipeRepository, List<Recipe>>((ref) {
  return RecipeRepository();
});
