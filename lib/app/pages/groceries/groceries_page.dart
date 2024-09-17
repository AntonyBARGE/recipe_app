import 'package:flutter/material.dart';

import 'category/categories_list.dart';

class GroceriesPage extends StatelessWidget {
  const GroceriesPage({super.key});

  static const routeName = '/groceries';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: IngredientCategoriesList(),
      ),
    );
  }
}
