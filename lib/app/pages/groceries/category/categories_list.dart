import 'package:flutter/material.dart';
import 'package:recipe_app/app/pages/groceries/category/category_creation_tile.dart';

import '../../../../core/utils/logger.dart';
import '../../../modules/ingredient-category/domain/entities/ingredient_category_entity.dart';
import 'category_dropdown.dart';
import 'category_proxy_decorator.dart';

class IngredientCategoriesList extends StatefulWidget {
  final List<IngredientCategoryEntity> ingredientCategories;
  final void Function(String) addCategory;
  final void Function(int, int) reorderCategories;
  final void Function(IngredientCategoryEntity category) deleteCategory;
  final void Function(IngredientCategoryEntity category) editCategory;

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

class IngredientCategoriesListState extends State<IngredientCategoriesList>
    with TickerProviderStateMixin {
  bool _isDragging = false;
  double _dx = 0;
  double _dy = 0;
  late double _actionThreshold;
  final double _vThreshold = 20;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _actionThreshold = MediaQuery.of(context).size.width * 0.6;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<IngredientCategoryEntity> categories = widget.ingredientCategories
      ..sort((a, b) => a.position.compareTo(b.position));

    return Listener(
      onPointerMove: (PointerMoveEvent event) {
        if (_isDragging) {
          setState(() {
            _dx += event.delta.dx;
            _dy += event.delta.dy;
          });

          if (_dx.abs() > _actionThreshold && _dy.abs() < _vThreshold) {
            if (_dx > 0) {
              logger.i('delete');
              // widget.deleteCategory(_categories[_draggedIndex]);
            } else {
              logger.i('edit');
              // widget.editCategory(_categories[_draggedIndex]);
            }
            setState(() {
              _dx = 0;
            });
          }
        }
      },
      onPointerUp: (_) {
        if (_isDragging) {
          setState(() {
            _dx = 0;
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
            },
            onReorderEnd: (index) {
              _isDragging = false;
              _dx = 0;
              _dy = 0;
            },
            onReorder: widget.reorderCategories,
            padding: const EdgeInsets.only(bottom: 80),
            itemBuilder: (BuildContext context, int index) {
              final category = categories
                  .firstWhere((category) => category.position == index + 1);
              return IngredientCategoryDropdown(
                key: ValueKey(category.id),
                category: category,
              );
            },
            itemCount: categories.length,
            proxyDecorator: (child, index, animation) => CategoryProxyDecorator(
              key: ValueKey(categories[index].id),
              index: index,
              animation: animation,
              dx: _dx,
              category: categories[index],
              actionThreshold: _actionThreshold,
              onDelete: () => widget.deleteCategory(categories[index]),
              onEdit: () => widget.editCategory(categories[index]),
              isChangingPosition: _dy.abs() < _vThreshold,
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
