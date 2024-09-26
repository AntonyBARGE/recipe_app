import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utils/logger.dart';
import '../../../modules/ingredient-category/domain/entities/ingredient_category_entity.dart';
import 'category_dropdown.dart';
import 'category_proxy_decorator.dart';

class IngredientCategoriesList extends StatefulWidget {
  final List<IngredientCategoryEntity> ingredientCategories;
  final void Function(IngredientCategoryEntity) addCategory;
  final void Function(List<IngredientCategoryEntity> categories)
      updateCategories;
  final void Function(IngredientCategoryEntity category) deleteCategory;
  final void Function(IngredientCategoryEntity category) editCategory;

  const IngredientCategoriesList({
    super.key,
    required this.ingredientCategories,
    required this.addCategory,
    required this.updateCategories,
    required this.deleteCategory,
    required this.editCategory,
  });

  @override
  IngredientCategoriesListState createState() =>
      IngredientCategoriesListState();
}

class IngredientCategoriesListState extends State<IngredientCategoriesList>
    with TickerProviderStateMixin {
  bool _isCreatingCategory = false;
  bool _isDragging = false;
  double _dx = 0;
  double _dy = 0;
  late double _actionThreshold;
  final double _vThreshold = 20;
  late List<IngredientCategoryEntity> _categories;
  final TextEditingController _categoryController = TextEditingController();
  final Map<int, bool> _expandedStates = {};

  @override
  void initState() {
    super.initState();
    _categories = List.from(widget.ingredientCategories);
    for (var category in widget.ingredientCategories) {
      _expandedStates[category.position] = false;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _actionThreshold = MediaQuery.of(context).size.width * 0.6;
    });
  }

  Future<void> _onReorder(int oldIndex, int newIndex) async {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final movedCategory = _categories.removeAt(oldIndex);
      _categories.insert(newIndex, movedCategory);
      for (int i = 0; i < _categories.length; i++) {
        _categories[i] = _categories[i].copyWith(position: i + 1);
      }
      widget.updateCategories(_categories);
    });
  }

  void _toggleExpansion(int position) {
    setState(() {
      _expandedStates[position] = !_expandedStates[position]!;
    });
  }

  void _createCategory() {
    const uuid = Uuid();
    final newCategoryName = _categoryController.text;
    if (newCategoryName.isNotEmpty) {
      final newCategory = IngredientCategoryEntity(
        id: uuid.v1(),
        name: newCategoryName,
        position: _categories.length + 1,
      );
      setState(() {
        _categories.add(newCategory);
        _isCreatingCategory = false;
      });
      widget.addCategory(newCategory);
      _categoryController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

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
        setState(() {
          _dx = 0;
          _isDragging = false;
        });
      },
      child: Column(
        children: [
          Expanded(
            child: ReorderableListView.builder(
              onReorderStart: (index) => _isDragging = true,
              onReorderEnd: (index) {
                _isDragging = false;
                _dx = 0;
                _dy = 0;
              },
              onReorder: _onReorder,
              padding: const EdgeInsets.only(bottom: 80),
              itemBuilder: (BuildContext context, int index) {
                final category = _categories
                    .firstWhere((category) => category.position == index + 1);
                return IngredientCategoryDropdown(
                  key: ValueKey(category.id),
                  category: category,
                  toggleExpansion: _toggleExpansion,
                  isExpanded: _expandedStates[category.position] ?? false,
                );
              },
              itemCount: _categories.length,
              proxyDecorator: (child, index, animation) =>
                  CategoryProxyDecorator(
                key: ValueKey(_categories[index].id),
                index: index,
                animation: animation,
                dx: _dx,
                toggleExpansion: (index) => _toggleExpansion(index + 1),
                category: _categories[index],
                actionThreshold: _actionThreshold,
                onDelete: () => widget.deleteCategory(_categories[index]),
                onEdit: () => widget.editCategory(_categories[index]),
                isChangingPosition: _dy.abs() < _vThreshold,
                child: child,
              ),
            ),
          ),
          if (_isCreatingCategory)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _categoryController,
                    decoration: const InputDecoration(
                      labelText: 'Category Name',
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _createCategory,
                    child: const Text('Create Category'),
                  ),
                ],
              ),
            ),
          _buildAddCategoryTile(theme),
        ],
      ),
    );
  }

  Widget _buildAddCategoryTile(TextTheme theme) {
    return ListTile(
      title: Text(
        'Add New Category',
        style: theme.titleLarge?.copyWith(color: Colors.blue),
      ),
      onTap: () {
        setState(() {
          _isCreatingCategory = !_isCreatingCategory;
        });
      },
    );
  }
}
