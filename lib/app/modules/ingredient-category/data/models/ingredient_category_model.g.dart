// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IngredientCategoryModel _$IngredientCategoryModelFromJson(
        Map<String, dynamic> json) =>
    IngredientCategoryModel(
      name: json['name'] as String,
      id: json['id'] as String,
      position: (json['position'] as num).toInt(),
    );

Map<String, dynamic> _$IngredientCategoryModelToJson(
        IngredientCategoryModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'position': instance.position,
    };
