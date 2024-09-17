import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/recipe.dart';
import '../models/recipe_category.dart';

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
      onCreate: (db, version) async {
        await db.execute(
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

        await db.execute(
          '''
          CREATE TABLE recipe_categories (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT
          )
          ''',
        );

        await db.execute(
          '''
          CREATE TABLE recipe_category_relations (
            recipeId INTEGER,
            categoryId INTEGER,
            PRIMARY KEY (recipeId, categoryId),
            FOREIGN KEY (recipeId) REFERENCES recipes(id) ON DELETE CASCADE,
            FOREIGN KEY (categoryId) REFERENCES recipe_categories(id) ON DELETE CASCADE
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
    final List<Map<String, dynamic>> recipeMaps = await db.query('recipes');

    return Future.wait(recipeMaps.map<Future<Recipe>>((recipeMap) async {
      final List<Map<String, dynamic>> categoryMaps = await db.rawQuery(
        '''
        SELECT rc.* FROM recipe_categories rc
        INNER JOIN recipe_category_relations rcr ON rc.id = rcr.categoryId
        WHERE rcr.recipeId = ?
        ''',
        [recipeMap['id']],
      );

      final categories =
          categoryMaps.map((map) => RecipeCategory.fromMap(map)).toList();

      return Recipe.fromMap(recipeMap, categories);
    }).toList());
  }

  Future<RecipeCategory?> getCategoryById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'recipe_categories',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return RecipeCategory.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<Recipe> addRecipe(Recipe recipe) async {
    final id = await _persistRecipe(recipe);
    final newRecipe = recipe.copyWith(id: id);
    state = [...state, newRecipe];
    return newRecipe;
  }

  void updateRecipe(Recipe updatedRecipe) {
    state = state.map((recipe) {
      return recipe.id == updatedRecipe.id ? updatedRecipe : recipe;
    }).toList();
    _persistRecipe(updatedRecipe);
  }

  void deleteRecipe(int id) {
    state = state.where((recipe) => recipe.id != id).toList();
    _deleteRecipeFromDb(id);
  }

  Future<int> _persistRecipe(Recipe recipe) async {
    final db = await database;
    final recipeMap = recipe.toMap();

    int recipeId;
    if (recipe.id == null) {
      recipeId = await db.insert('recipes', recipeMap);
    } else {
      recipeId = recipe.id!;
      await db.update('recipes', recipeMap,
          where: 'id = ?', whereArgs: [recipe.id]);
    }

    await db.delete('recipe_category_relations',
        where: 'recipeId = ?', whereArgs: [recipeId]);

    for (final category in recipe.categories) {
      await db.insert('recipe_category_relations', {
        'recipeId': recipeId,
        'categoryId': category.id,
      });
    }

    return recipeId;
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
