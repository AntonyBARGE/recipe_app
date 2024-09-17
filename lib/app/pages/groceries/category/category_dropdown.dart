import 'package:flutter/material.dart';
import 'package:recipe_app/app/modules/ingredient-category/domain/entities/ingredient_category_entity.dart';

class CategoryDropdown extends StatefulWidget {
  final IngredientCategoryEntity category;
  final List<Widget> children;
  const CategoryDropdown(
      {required this.category, required this.children, super.key});

  @override
  State<CategoryDropdown> createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(widget.category.name),
      trailing: Icon(
        _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
      ),
      onExpansionChanged: (bool expanded) {
        setState(() {
          _isExpanded = expanded;
        });
      },
      children: widget.children,
    );
  }
}
