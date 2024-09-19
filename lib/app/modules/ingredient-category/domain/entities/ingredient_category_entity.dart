import 'package:equatable/equatable.dart';

import '../../../../../core/clean-archi/clean_archi_base_components.dart';

// ignore: must_be_immutable
class IngredientCategoryEntity extends Equatable implements BaseEntity {
  String name;
  String id;
  int position;

  IngredientCategoryEntity({
    required this.name,
    required this.id,
    required this.position,
  });

  @override
  List<Object?> get props => [name, id, position];

  IngredientCategoryEntity copyWith({
    String? name,
    String? id,
    int? position,
  }) {
    return IngredientCategoryEntity(
      name: name ?? this.name,
      id: id ?? this.id,
      position: position ?? this.position,
    );
  }
}
