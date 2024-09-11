import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/ingredient.dart';
import '../../repositories/recipe_repository.dart';

class MealDetailsPage extends ConsumerWidget {
  final int recipeId;
  static const routeName = 'recipe_details';

  const MealDetailsPage({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipe = ref
        .watch(recipeRepositoryProvider)
        .firstWhere((recipe) => recipe.id == recipeId);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          recipe.name,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Implement share functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              // Implement favorite functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                recipe.pictureUrl ??
                    'https://via.placeholder.com/400x300', // Fallback image
                height: 250.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              recipe.name,
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.orange),
                Text('${recipe.note ?? 0}'),
                const SizedBox(width: 16.0),
                const Icon(Icons.timer, color: Colors.grey),
                Text('${recipe.prepTime} min'),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Ingrédients',
            ),
            const SizedBox(height: 8.0),
            ...recipe.ingredients.map((ingredient) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    '${ingredient.quantity}${ingredient.unit == Unit.piece ? '' : ' ${ingredient.unit.toString().split('.').last}'} ${ingredient.name}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                )),
            const SizedBox(height: 16.0),
            const Text(
              'Instructions',
            ),
            const SizedBox(height: 8.0),
            ...recipe.instructions.map(
              (instruction) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  instruction,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
