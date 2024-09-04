import 'package:flutter/material.dart';
import 'package:recipe_app/app/models/recipe.dart';

class MealsSearchBar extends StatefulWidget {
  const MealsSearchBar({super.key, required this.recipes});

  final List<Recipe> recipes;

  @override
  State<MealsSearchBar> createState() => _MealsSearchBarState();
}

class _MealsSearchBarState extends State<MealsSearchBar> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final filteredRecipes = widget.recipes
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
              setState(() {
                searchQuery = value;
              });
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
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
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
