import 'package:equatable/equatable.dart';

import '../../../../../core/clean-archi/clean_archi_base_components.dart';

// ignore: must_be_immutable
class IngredientCategoryEntity extends Equatable implements BaseEntity {
  String name;
  int id;

  IngredientCategoryEntity({
    required this.name,
    required this.id,
  });

  @override
  List<Object?> get props => [name, id];
}
