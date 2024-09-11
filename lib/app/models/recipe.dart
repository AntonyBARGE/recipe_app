import 'ingredient.dart';
import 'recipe_category.dart';

class Recipe {
  final int? id;
  final String name;
  final String description;
  final String? pictureUrl;
  final double? note;
  final List<RecipeCategory> categories;
  final int prepTime;
  final int cookTime;
  final int totalTime;
  final int numberOfPersons;
  final List<Ingredient> ingredients;
  final List<String> instructions;
  final Map<String, String>? nutrition;

  Recipe({
    this.id,
    required this.name,
    required this.description,
    this.pictureUrl,
    this.note,
    required this.categories,
    required this.prepTime,
    required this.cookTime,
    required this.totalTime,
    required this.numberOfPersons,
    required this.ingredients,
    required this.instructions,
    this.nutrition,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'pictureUrl': pictureUrl,
      'note': note,
      'prepTime': prepTime,
      'cookTime': cookTime,
      'totalTime': totalTime,
      'numberOfPersons': numberOfPersons,
      'ingredients': ingredients.map((e) => e.toString()).join(','),
      'instructions': instructions.join(','),
      'nutrition':
          nutrition?.entries.map((e) => '${e.key}:${e.value}').join(','),
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      pictureUrl: map['pictureUrl'],
      note: map['note'],
      categories: [],
      prepTime: map['prepTime'],
      cookTime: map['cookTime'],
      totalTime: map['totalTime'],
      numberOfPersons: map['numberOfPersons'],
      ingredients: (map['ingredients'] as String)
          .split(',')
          .map((e) => Ingredient.fromString(e))
          .toList(),
      instructions: (map['instructions'] as String).split(',').toList(),
      nutrition: map['nutrition'] != null
          ? Map.fromEntries(
              (map['nutrition'] as String).split(',').map((e) {
                final parts = e.split(':');
                return MapEntry(parts[0].trim(), parts[1].trim());
              }),
            )
          : null,
    );
  }

  @override
  String toString() {
    final ingredientList =
        ingredients.map((ingredient) => ingredient.toString()).join(', ');
    final instructionList = instructions
        .asMap()
        .entries
        .map((entry) => '${entry.key + 1}. ${entry.value}')
        .join('\n');
    final nutritionList = nutrition?.entries
        .map((entry) => '${entry.key}: ${entry.value}')
        .join(', ');

    return '''
Recipe: $name
Description: $description
Categories: ${categories.map((c) => c.name).join(', ')}
Prep Time: $prepTime mins, Cook Time: $cookTime mins, Total Time: $totalTime mins
Serves: $numberOfPersons
Ingredients:
$ingredientList

Instructions:
$instructionList

Nutrition:
$nutritionList
    ''';
  }

  Recipe copyWith({
    int? id,
    String? name,
    String? description,
    String? pictureUrl,
    double? note,
    List<RecipeCategory>? categories,
    int? prepTime,
    int? cookTime,
    int? totalTime,
    int? numberOfPersons,
    List<Ingredient>? ingredients,
    List<String>? instructions,
    Map<String, String>? nutrition,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      pictureUrl: pictureUrl ?? this.pictureUrl,
      note: note ?? this.note,
      categories: categories ?? this.categories,
      prepTime: prepTime ?? this.prepTime,
      cookTime: cookTime ?? this.cookTime,
      totalTime: totalTime ?? this.totalTime,
      numberOfPersons: numberOfPersons ?? this.numberOfPersons,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      nutrition: nutrition ?? this.nutrition,
    );
  }
}
