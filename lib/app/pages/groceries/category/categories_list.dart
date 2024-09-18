import 'package:flutter/material.dart';

import '../../../modules/ingredient-category/domain/entities/ingredient_category_entity.dart';

class IngredientCategoriesList extends StatefulWidget {
  final List<IngredientCategoryEntity> ingredientCategories;
  final void Function(String categoryName) addCategory;

  const IngredientCategoriesList({
    super.key,
    required this.ingredientCategories,
    required this.addCategory,
  });

  @override
  IngredientCategoriesListState createState() =>
      IngredientCategoriesListState();
}

class IngredientCategoriesListState extends State<IngredientCategoriesList> {
  final Map<int, bool> _expandedStates = {};
  bool _isCreatingCategory = false;
  final TextEditingController _categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    for (var category in widget.ingredientCategories) {
      _expandedStates.putIfAbsent(category.id, () => false);
    }
    print(widget.ingredientCategories);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: ExpansionPanelList(
        elevation: 1,
        expandedHeaderPadding: EdgeInsets.zero,
        materialGapSize: 0,
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            if (index == widget.ingredientCategories.length) {
              _isCreatingCategory = !_isCreatingCategory;
            } else {
              final categoryId = widget.ingredientCategories[index].id;
              _expandedStates[categoryId] = !isExpanded;
            }
          });
        },
        children: [
          ...widget.ingredientCategories.map<ExpansionPanel>((category) {
            return ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return GestureDetector(
                  onTap: () => setState(() {
                    _expandedStates[category.id] =
                        !_expandedStates[category.id]!;
                  }),
                  child: ListTile(
                    title: Text(category.name),
                  ),
                );
              },
              body: Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                color: Colors.yellow,
                child: Text('Unknown state', style: theme.bodyLarge),
              ),
              isExpanded: _expandedStates[category.id] ?? false,
            );
          }),
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(
                  'Add New Category',
                  style: theme.titleLarge?.copyWith(color: Colors.blue),
                ),
              );
            },
            body: Padding(
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
                    onPressed: () {
                      final newCategoryName = _categoryController.text;
                      if (newCategoryName.isNotEmpty) {
                        widget.addCategory(newCategoryName);
                        _categoryController.clear();
                        setState(() {
                          _isCreatingCategory = false;
                        });
                      }
                    },
                    child: const Text('Create Category'),
                  ),
                ],
              ),
            ),
            isExpanded: _isCreatingCategory,
          ),
        ],
      ),
    );
  }
}
