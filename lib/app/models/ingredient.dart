import '../modules/ingredient-category/domain/entities/ingredient_category_entity.dart';

class Ingredient {
  final int? id;
  final String name;
  final String? pictureUrl;
  final IngredientCategoryEntity? category;

  Ingredient({
    this.id,
    required this.name,
    this.pictureUrl,
    this.category,
  });

  Ingredient copyWith({
    int? id,
    String? name,
    String? pictureUrl,
    IngredientCategoryEntity? category,
  }) {
    return Ingredient(
      id: id ?? this.id,
      name: name ?? this.name,
      pictureUrl: pictureUrl ?? this.pictureUrl,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'pictureUrl': pictureUrl,
      'categoryId': category?.id,
    };
  }

  static Ingredient fromMap(Map<String, dynamic> map) {
    return Ingredient(
      id: map['id'],
      name: map['name'],
      pictureUrl: map['pictureUrl'],
      category: map['categoryId'] != null
          ? IngredientCategoryEntity(
              id: map['categoryId'], name: 'oui', position: -1)
          : null,
    );
  }
}
