import 'package:flutter/material.dart';
import 'package:recipe_app/app/modules/ingredient-category/domain/entities/ingredient_category_entity.dart';

class IngredientCategoryDropdown extends StatelessWidget {
  const IngredientCategoryDropdown({
    super.key,
    required this.category,
    required this.toggleExpansion,
    required this.isExpanded,
    this.elevation,
    this.isDragged = false,
  });

  final IngredientCategoryEntity category;
  final void Function(int) toggleExpansion;
  final bool isExpanded;
  final double? elevation;
  final bool isDragged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Card(
      elevation: elevation ?? 1,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        children: [
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            leading: const Icon(Icons.drag_indicator),
            title: Text(
              category.name,
              style: theme.titleMedium,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            trailing: !isDragged
                ? Icon((isExpanded ? Icons.expand_less : Icons.expand_more))
                : null,
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
