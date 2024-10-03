import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../modules/ingredient-category/domain/entities/ingredient_category_entity.dart';

final expandedStateProvider =
    StateProvider.family<bool, String>((ref, categoryId) => false);

class IngredientCategoryDropdown extends ConsumerWidget {
  const IngredientCategoryDropdown({
    super.key,
    required this.category,
    this.elevation,
    this.isDragged = false,
  });

  final IngredientCategoryEntity category;
  final double? elevation;
  final bool isDragged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).textTheme;
    final isExpanded = ref.watch(expandedStateProvider(category.id));

    return Card(
      elevation: elevation ?? 1,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        key: PageStorageKey(category.id),
        leading: const Icon(Icons.drag_indicator),
        title: Text(
          category.name,
          style: theme.titleMedium,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        trailing: !isDragged
            ? Icon(isExpanded ? Icons.expand_less : Icons.expand_more)
            : null,
        initiallyExpanded: isExpanded,
        onExpansionChanged: (expanded) {
          ref
              .read(expandedStateProvider(category.id).notifier)
              .update((state) => expanded);
        },
        tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
        childrenPadding: EdgeInsets.zero,
        maintainState: true,
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            color: Colors.yellow[100],
            child: Text(
              'Details of ${category.name}',
              style: theme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
