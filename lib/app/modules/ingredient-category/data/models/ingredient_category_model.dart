import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../../core/clean-archi/clean_archi_base_components.dart';

part 'ingredient_category_model.g.dart';

// fvm flutter pub run build_runner build --delete-conflicting-outputs

@JsonSerializable()
class IngredientCategoryModel extends Equatable implements BaseModel {
  final String name;
  final int id;

  const IngredientCategoryModel({
    required this.name,
    required this.id,
  });

  @override
  List<Object?> get props => [name, id];

  factory IngredientCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$IngredientCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientCategoryModelToJson(this);
}
