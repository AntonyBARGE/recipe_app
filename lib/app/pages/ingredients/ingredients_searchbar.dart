import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/app/pages/meals/meals_page.dart';

import '../../repositories/ingredient_repository.dart';
import '../meals/details/meal_details_page.dart';

class IngredientsSearchBar extends ConsumerStatefulWidget {
  const IngredientsSearchBar({super.key});

  @override
  IngredientsSearchBarState createState() => IngredientsSearchBarState();
}

class IngredientsSearchBarState extends ConsumerState<IngredientsSearchBar> {
  final searchQueryProvider = StateProvider<String>((ref) => '');

  @override
  Widget build(BuildContext context) {
    final ingredients = ref.watch(ingredientRepositoryProvider);
    final theme = Theme.of(context).textTheme;
    final searchQuery = ref.watch(searchQueryProvider);

    final filteredIngredients = ingredients
        .where((ingredient) =>
            ingredient.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            ingredient.category!.name
                .toLowerCase()
                .contains(searchQuery.toLowerCase()))
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Search Ingredient',
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
            itemCount: filteredIngredients.length,
            itemBuilder: (context, index) {
              final ingredient = filteredIngredients[index];
              return GestureDetector(
                onTap: () {
                  context.push(
                    '${MealsPage.routeName}/${MealDetailsPage.routeName}/${ingredient.id}',
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
                          ingredient.name,
                          style: theme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          ingredient.toString(),
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
