import 'package:flutter/foundation.dart';

class Ingredient {
  final String name;
  final double quantity;
  final Unit unit;
  final Category? category;

  Ingredient({
    required this.name,
    required this.quantity,
    required this.unit,
    this.category,
  });

  @override
  String toString() {
    return '$quantity${_unitToString(unit)} of $name';
  }

  String _unitToString(Unit unit) {
    switch (unit) {
      case Unit.gram:
        return ' g';
      case Unit.kilogram:
        return ' kg';
      case Unit.milliliter:
        return ' ml';
      case Unit.liter:
        return ' L';
      case Unit.teaspoon:
        return ' c.';
      case Unit.tablespoon:
        return ' c.à s.';
      case Unit.cup:
        return ' verre${quantity > 1 ? 's' : ''}';
      case Unit.piece:
        return '';
      case Unit.pinch:
        return 'pincée${quantity > 1 ? 's' : ''}';
      default:
        return '';
    }
  }
}

enum Unit {
  gram,
  kilogram,
  milliliter,
  liter,
  teaspoon,
  tablespoon,
  cup,
  piece,
  pinch,
}
