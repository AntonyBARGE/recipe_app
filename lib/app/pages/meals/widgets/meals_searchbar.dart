import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../repositories/recipe_repository.dart';
import '../meal_details_page.dart';
import '../meals_page.dart';

class MealsSearchBar extends ConsumerStatefulWidget {
  const MealsSearchBar({super.key});

  @override
  MealsSearchBarState createState() => MealsSearchBarState();
}

class MealsSearchBarState extends ConsumerState<MealsSearchBar> {
  final searchQueryProvider = StateProvider<String>((ref) => '');

  @override
  Widget build(BuildContext context) {
    final recipes = ref.watch(recipeRepositoryProvider);
    final theme = Theme.of(context).textTheme;
    final searchQuery = ref.watch(searchQueryProvider);

    final filteredRecipes = recipes
        .where((recipe) =>
            recipe.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            recipe.ingredients.any((ingredient) => ingredient.name
                .toLowerCase()
                .contains(searchQuery.toLowerCase())))
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Search Recipe',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              ref.read(searchQueryProvider.notifier).state = value;
            },
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(10.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 columns
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2 / 3,
            ),
            itemCount: filteredRecipes.length,
            itemBuilder: (context, index) {
              final recipe = filteredRecipes[index];
              return GestureDetector(
                onTap: () {
                  context.push(
                    '${MealsPage.routeName}/${MealDetailsPage.routeName}/${recipe.id}',
                  );
                },
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          recipe.name,
                          style: theme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          recipe.ingredients
                              .map((ingredient) => ingredient.name)
                              .join(', '),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
