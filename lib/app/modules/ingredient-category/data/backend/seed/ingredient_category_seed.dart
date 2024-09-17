import 'package:sqflite/sqflite.dart';

import '../../../../../../core/utils/db_constants.dart';

class IngredientCategorySeed {
  static Future<void> seed(Database db) async {
    final List<Map<String, dynamic>> initialCategories = [
      {'name': 'Fruits & Légumes'},
      {'name': 'Pains & Pâtisseries'},
      {'name': 'Produits laitiers'},
      {'name': 'Viandes & Poissons'},
      {'name': 'Ingrédients & Épices'},
      {'name': 'Surgelés & Plats cuisinés'},
      {'name': 'Pâtes, Riz & Céréales'},
      {'name': 'Snacks & Friandises'},
      {'name': 'Boissons'},
      {'name': 'Entretien'},
      {'name': 'Soin & Santé'},
      {'name': 'Animaux'},
      {'name': 'Jardin & Artisanat'},
      {'name': 'Autres'},
    ];

    final count = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM ${DatabaseStore.INGREDIENT_CATEGORY_DATA}'));

    if (count == 0) {
      final batch = db.batch();
      for (var category in initialCategories) {
        batch.insert(
          DatabaseStore.INGREDIENT_CATEGORY_DATA,
          category,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit();
    }
  }
}
