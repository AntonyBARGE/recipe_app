class Ingredient {
  final String name;
  final double quantity;
  final Unit unit;

  Ingredient({
    required this.name,
    required this.quantity,
    required this.unit,
  });

  @override
  String toString() {
    return '$quantity ${_unitToString(unit)} of $name';
  }

  String _unitToString(Unit unit) {
    switch (unit) {
      case Unit.gram:
        return 'g';
      case Unit.kilogram:
        return 'kg';
      case Unit.milliliter:
        return 'ml';
      case Unit.liter:
        return 'L';
      case Unit.teaspoon:
        return 'cu';
      case Unit.tablespoon:
        return 'càs';
      case Unit.cup:
        return 'verre';
      case Unit.piece:
        return 'piece${quantity > 1 ? 's' : ''}';
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
