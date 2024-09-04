import 'ingredient.dart';

class Recipe {
  final String name;
  final List<Ingredient> ingredients;
  final List<String> instructions;

  Recipe({
    required this.name,
    required this.ingredients,
    required this.instructions,
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

    return '''
Recipe: $name

Ingredients:
$ingredientList

Instructions:
$instructionList
    ''';
  }
}
