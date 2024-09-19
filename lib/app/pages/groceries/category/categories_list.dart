import 'package:flutter/material.dart';
import 'package:recipe_app/app/pages/groceries/category/category_dropdown.dart';
import 'package:uuid/uuid.dart';

import '../../../modules/ingredient-category/domain/entities/ingredient_category_entity.dart';

class IngredientCategoriesList extends StatefulWidget {
  final List<IngredientCategoryEntity> ingredientCategories;
  final void Function(IngredientCategoryEntity) addCategory;
  final void Function(List<IngredientCategoryEntity> categories)
      updateCategories;

  const IngredientCategoriesList({
    super.key,
    required this.ingredientCategories,
    required this.addCategory,
    required this.updateCategories,
  });

  @override
  IngredientCategoriesListState createState() =>
      IngredientCategoriesListState();
}

class IngredientCategoriesListState extends State<IngredientCategoriesList> {
  bool _isCreatingCategory = false;
  final TextEditingController _categoryController = TextEditingController();
  late List<IngredientCategoryEntity> _categories;
  final Map<int, bool> _expandedStates = {};

  @override
  void initState() {
    super.initState();
    _categories = List.from(widget.ingredientCategories);
    for (var category in widget.ingredientCategories) {
      _expandedStates[category.position] = false;
    }
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

    return Column(
      children: [
        Expanded(
          child: ReorderableListView.builder(
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
