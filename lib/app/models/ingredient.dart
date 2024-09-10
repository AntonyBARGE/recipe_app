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

  static Ingredient fromString(String ingredientString) {
    final quantityRegex = RegExp(r'([\d.]+)');
    final unitRegex = RegExp(r'(g|kg|ml|L|c\.|c\.à s\.|verre|pincée)?');

    final quantityMatch = quantityRegex.firstMatch(ingredientString);
    final unitMatch = unitRegex.firstMatch(ingredientString);

    final quantity =
        quantityMatch != null ? double.parse(quantityMatch.group(1)!) : 1.0;

    final unitString = unitMatch?.group(1) ?? '';
    Unit unit;
    switch (unitString) {
      case 'g':
        unit = Unit.gram;
        break;
      case 'kg':
        unit = Unit.kilogram;
        break;
      case 'ml':
        unit = Unit.milliliter;
        break;
      case 'L':
        unit = Unit.liter;
        break;
      case 'c.':
        unit = Unit.teaspoon;
        break;
      case 'c.à s.':
        unit = Unit.tablespoon;
        break;
      case 'verre':
        unit = Unit.cup;
        break;
      case 'pincée':
        unit = Unit.pinch;
        break;
      default:
        unit = Unit.piece;
    }

    final name = ingredientString
        .replaceFirst(quantityMatch?.group(0) ?? '', '')
        .replaceFirst(unitString, '')
        .trim();

    return Ingredient(
      name: name,
      quantity: quantity,
      unit: unit,
    );
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
