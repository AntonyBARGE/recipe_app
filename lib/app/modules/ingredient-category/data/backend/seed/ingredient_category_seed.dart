import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../core/utils/db_constants.dart';

class IngredientCategorySeed {
  static Future<void> seed(Database db) async {
    const Uuid uuid = Uuid();
    final List<Map<String, dynamic>> initialCategories = [
      {'id': uuid.v1(), 'name': 'Fruits & Légumes', 'position': 1},
      {'id': uuid.v1(), 'name': 'Pains & Pâtisseries', 'position': 2},
      {'id': uuid.v1(), 'name': 'Produits laitiers', 'position': 3},
      {'id': uuid.v1(), 'name': 'Viandes & Poissons', 'position': 4},
      {'id': uuid.v1(), 'name': 'Ingrédients & Épices', 'position': 5},
      {'id': uuid.v1(), 'name': 'Surgelés & Plats cuisinés', 'position': 6},
      {'id': uuid.v1(), 'name': 'Pâtes, Riz & Céréales', 'position': 7},
      {'id': uuid.v1(), 'name': 'Snacks & Friandises', 'position': 8},
      {'id': uuid.v1(), 'name': 'Boissons', 'position': 9},
      {'id': uuid.v1(), 'name': 'Entretien', 'position': 10},
      {'id': uuid.v1(), 'name': 'Soin & Santé', 'position': 11},
      {'id': uuid.v1(), 'name': 'Animaux', 'position': 12},
      {'id': uuid.v1(), 'name': 'Autres', 'position': 13},
    ];

    final count = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM ${DatabaseStore.INGREDIENT_CATEGORY_DATA}'));

    if (count == 0) {
      final batch = db.batch();
      for (var category in initialCategories) {
        batch.insert(
          DatabaseStore.INGREDIENT_CATEGORY_DATA,
          category,
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
      await batch.commit();
    }
  }
}
