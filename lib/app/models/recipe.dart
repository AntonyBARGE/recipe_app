import 'ingredient.dart';
import 'recipe_category.dart';

class Recipe {
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
}
