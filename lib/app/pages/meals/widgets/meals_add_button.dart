import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/recipe_creation.dart';

class MealsAddButton extends StatelessWidget {
  const MealsAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.pushNamed(RecipeCreationPage.routeName);
      },
      child: const Icon(Icons.add),
    );
  }
}
