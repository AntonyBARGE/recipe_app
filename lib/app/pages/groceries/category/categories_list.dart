import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/app/pages/groceries/category/category_creation_tile.dart';

import '../../../modules/ingredient-category/domain/entities/ingredient_category_entity.dart';
import 'category_dropdown.dart';
import 'category_proxy_decorator.dart';

final dxProvider = StateProvider<double>((ref) => 0.0);
final dyProvider = StateProvider<double>((ref) => 0.0);

class IngredientCategoriesList extends ConsumerStatefulWidget {
  final List<IngredientCategoryEntity> ingredientCategories;
  final void Function(String) addCategory;
  final void Function(int, int) reorderCategories;
  final void Function(String, int) deleteCategory;
  final void Function(String, String) editCategory;

  const IngredientCategoriesList({
    super.key,
    required this.ingredientCategories,
    required this.addCategory,
    required this.reorderCategories,
    required this.deleteCategory,
    required this.editCategory,
  });

  @override
  IngredientCategoriesListState createState() =>
      IngredientCategoriesListState();
}

class IngredientCategoriesListState
    extends ConsumerState<IngredientCategoriesList>
    with TickerProviderStateMixin {
  bool _isDragging = false;
  int _draggedIndex = -1;
  late double _actionThreshold;
  final double _vThreshold = 20;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _actionThreshold = MediaQuery.of(context).size.width * 0.3;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<IngredientCategoryEntity> categories = widget.ingredientCategories
      ..sort((a, b) => a.position.compareTo(b.position));

    return Listener(
      onPointerMove: (PointerMoveEvent event) {
        if (_isDragging && mounted && _draggedIndex < categories.length) {
          ref
              .read(dxProvider.notifier)
              .update((state) => state + event.delta.dx);
          ref
              .read(dyProvider.notifier)
              .update((state) => state + event.delta.dy);

          if (ref.read(dxProvider).abs() > _actionThreshold &&
              ref.read(dyProvider).abs() < _vThreshold) {
            if (ref.read(dxProvider) > 0) {
              widget.deleteCategory(
                categories[_draggedIndex].id,
                categories[_draggedIndex].position,
              );
            } else {
              log('edit');
              ref
                  .read(editStateProvider.notifier)
                  .update((state) => categories[_draggedIndex].id);
            }
            ref.read(dxProvider.notifier).update((state) => 0);
          }
        }
      },
      onPointerUp: (_) {
        if (_isDragging && mounted) {
          ref.read(dxProvider.notifier).update((state) => 0);
          ref.read(dyProvider.notifier).update((state) => 0);
          setState(() {
            _isDragging = false;
          });
        }
      },
      child: ListView(
        children: [
          ReorderableListView.builder(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            onReorderStart: (index) {
              _isDragging = true;
              _draggedIndex = index;
            },
            onReorderEnd: (index) {
              _isDragging = false;
              ref.read(dxProvider.notifier).update((state) => 0);
              ref.read(dyProvider.notifier).update((state) => 0);
            },
            onReorder: widget.reorderCategories,
            padding: const EdgeInsets.only(bottom: 80),
            itemBuilder: (BuildContext context, int index) {
              final category = categories
                  .firstWhere((category) => category.position == index + 1);
              return IngredientCategoryDropdown(
                key: ValueKey(category.id),
                category: category,
                editCategory: widget.editCategory,
              );
            },
            itemCount: categories.length,
            proxyDecorator: (child, index, animation) => CategoryProxyDecorator(
              key: ValueKey(categories[index].id),
              index: index,
              animation: animation,
              category: categories[index],
              actionThreshold: _actionThreshold,
              isChangingPosition: ref.read(dyProvider).abs() < _vThreshold,
              child: child,
            ),
          ),
          CategoryCreationTile(
            key: ValueKey(categories.length + 1),
            addCategory: widget.addCategory,
          ),
        ],
      ),
    );
  }
}
