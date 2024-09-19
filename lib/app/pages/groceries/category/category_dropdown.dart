import 'package:flutter/material.dart';
import 'package:recipe_app/app/modules/ingredient-category/domain/entities/ingredient_category_entity.dart';

class IngredientCategoryDropdown extends StatelessWidget {
  const IngredientCategoryDropdown({
    super.key,
    required this.category,
    required this.toggleExpansion,
    required this.isExpanded,
  });

  final IngredientCategoryEntity category;
  final void Function(int) toggleExpansion;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.drag_indicator),
            title: Text(category.name, style: theme.titleMedium),
            trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
            onTap: () => toggleExpansion(category.position),
          ),
          if (isExpanded)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              color: Colors.yellow[100],
              child:
                  Text('Details of ${category.name}', style: theme.bodyLarge),
            ),
        ],
      ),
    );
  }
}
