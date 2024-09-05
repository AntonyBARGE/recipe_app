import 'package:flutter/material.dart';
import 'package:recipe_app/app/pages/meals/widgets/meals_header.dart';
import 'package:recipe_app/app/pages/meals/widgets/meals_searchbar.dart';

import 'widgets/meals_add_button.dart';

class MealsPage extends StatelessWidget {
  const MealsPage({super.key});

  static const routeName = '/meals';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: const Column(
            children: [
              MealsHeader(),
              Expanded(
                child: MealsSearchBar(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: const MealsAddButton(),
    );
  }
}
