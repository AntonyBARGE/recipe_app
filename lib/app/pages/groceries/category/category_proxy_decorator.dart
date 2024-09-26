import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../modules/ingredient-category/domain/entities/ingredient_category_entity.dart';
import 'category_dropdown.dart';

class CategoryProxyDecorator extends StatelessWidget {
  final Widget child;
  final int index;
  final Animation<double> animation;
  final double dx;
  final void Function(int) toggleExpansion;
  final bool isChangingPosition;
  final IngredientCategoryEntity category;
  final double actionThreshold;
  final void Function() onDelete;
  final void Function() onEdit;

  const CategoryProxyDecorator({
    super.key,
    required this.child,
    required this.index,
    required this.animation,
    required this.dx,
    required this.toggleExpansion,
    required this.isChangingPosition,
    required this.category,
    required this.actionThreshold,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    Color editColorStart = Colors.green[200]!;
    const Color editColorEnd = Colors.green;
    Color deleteColorStart = Colors.red[200]!;
    const Color deleteColorEnd = Colors.red;

    final bool isSwipingLeft = dx < 0;
    final bool isSwipingRight = dx > 0;

    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = lerpDouble(1, 6, animValue)!;
        final double scale = lerpDouble(1, 1.05, animValue)!;
        final double iconTranslation = lerpDouble(0, 16, animValue)!;
        final double normalizedDx =
            (dx.abs() / actionThreshold).clamp(0.0, 1.0);
        final Color editColor =
            Color.lerp(editColorStart, editColorEnd, normalizedDx)!;
        final Color deleteColor =
            Color.lerp(deleteColorStart, deleteColorEnd, normalizedDx)!;

        return ClipRect(
          child: Transform.scale(
            scale: scale,
            child: Stack(
              children: [
                if (isChangingPosition)
                  Positioned.fill(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          if (dx.abs() < 40 || dx > 40)
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(
                                  left: iconTranslation +
                                      (isSwipingRight ? (dx / 2) : 0),
                                ),
                                color: deleteColor,
                                alignment: Alignment.centerLeft,
                                child: const Icon(
                                  Icons.delete_forever,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          if (dx < -40 || dx.abs() < 40)
                            Expanded(
                              child: Container(
                                color: editColor,
                                padding: EdgeInsets.only(
                                    right: iconTranslation -
                                        (isSwipingLeft ? (dx / 2) : 0)),
                                alignment: Alignment.centerRight,
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: isChangingPosition ? 40 : 0),
                  child: Transform.translate(
                    offset: Offset(dx, 0),
                    child: IngredientCategoryDropdown(
                      key: ValueKey(category.id),
                      category: category,
                      toggleExpansion: toggleExpansion,
                      isExpanded: false,
                      elevation: elevation,
                      isDragged: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: child,
    );
  }
}
