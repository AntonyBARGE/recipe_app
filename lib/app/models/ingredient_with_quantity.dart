import 'package:recipe_app/app/models/ingredient.dart';

class IngredientWithQuantity {
  final int? id;
  final Ingredient ingredient;
  final double quantity;
  final Unit unit;

  IngredientWithQuantity({
    this.id,
    required this.ingredient,
    required this.quantity,
    required this.unit,
  });

  IngredientWithQuantity copyWith({
    int? id,
    Ingredient? ingredient,
    double? quantity,
    Unit? unit,
  }) {
    return IngredientWithQuantity(
      id: id ?? this.id,
      ingredient: ingredient ?? this.ingredient,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ingredient': ingredient.toMap(),
      'quantity': quantity,
      'unit': unit.index,
    };
  }

  static IngredientWithQuantity fromMap(Map<String, dynamic> map) {
    return IngredientWithQuantity(
      id: map['id'],
      quantity: map['quantity'],
      ingredient: map['ingredient'],
      unit: Unit.values[map['unit']],
    );
  }

  @override
  String toString() {
    return '$quantity${_unitToString(unit)} of id: $id';
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
