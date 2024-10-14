import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../modules/ingredient-category/domain/entities/ingredient_category_entity.dart';

final expandedStateProvider =
    StateProvider.family<bool, String>((ref, categoryId) => false);
final editStateProvider = StateProvider<String?>((ref) => null);
final categoryEditTextProvider = StateProvider<String>((ref) => '');

class IngredientCategoryDropdown extends ConsumerWidget {
  IngredientCategoryDropdown({
    super.key,
    required this.category,
    this.editCategory,
    this.elevation,
    this.isDragged = false,
  });

  final IngredientCategoryEntity category;
  final void Function(String categoryId, String newCategoryName)? editCategory;
  final double? elevation;
  final bool isDragged;
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).textTheme;
    final isExpanded = ref.watch(expandedStateProvider(category.id));
    final currentlyEditing = ref.watch(editStateProvider);
    final isEditing = currentlyEditing == category.id;

    return Card(
      elevation: elevation ?? 1,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        key: PageStorageKey(category.id),
        leading: isEditing
            ? const Icon(Icons.edit)
            : const Icon(Icons.drag_indicator),
        title: isEditing
            ? SizedBox(
                height: 36,
                child: TextField(
                  controller: controller,
                  maxLines: 1,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    filled: true,
                    border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                    contentPadding: const EdgeInsets.only(left: 16.0),
                    hintText: category.name,
                  ),
                  onChanged: (newCategoryName) {
                    ref
                        .read(categoryEditTextProvider.notifier)
                        .update((state) => newCategoryName);
                  },
                ),
              )
            : Text(
                category.name,
                style: theme.titleMedium,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
        trailing: isEditing
            ? IconButton(
                icon: const Icon(Icons.check),
                onPressed: () {
                  editCategory!(
                    category.id,
                    ref.read(categoryEditTextProvider),
                  );
                  ref.read(editStateProvider.notifier).update((state) => null);
                  ref
                      .read(categoryEditTextProvider.notifier)
                      .update((state) => '');
                },
              )
            : (!isDragged
                ? Icon(isExpanded ? Icons.expand_less : Icons.expand_more)
                : null),
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
