import 'package:equatable/equatable.dart';

import '../domain/entities/ingredient_category_entity.dart';

abstract class IngredientCategoriesState extends Equatable {
  const IngredientCategoriesState();

  @override
  List<Object?> get props => [];
}

class EmptyIngredientCategories extends IngredientCategoriesState {
  @override
  List<Object?> get props => [];
}

class IngredientCategoriesLoading extends IngredientCategoriesState {
  @override
  List<Object?> get props => [];
}

class IngredientCategoriesLoaded extends IngredientCategoriesState {
  final List<IngredientCategoryEntity> ingredientCategories;
  const IngredientCategoriesLoaded(this.ingredientCategories);

  @override
  List<Object?> get props => [ingredientCategories];
}
