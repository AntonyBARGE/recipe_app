import '../../../../../core/clean-archi/clean_archi_base_components.dart';
import '../entities/ingredient_category_entity.dart';
import '../repositories/ingredient_category_repository.dart';

class CreateIngredientCategory
    implements UseCase<IngredientCategoryEntity, IngredientCategoryEntity> {
  final IngredientCategoryRepository _repository;

  CreateIngredientCategory(this._repository);

  @override
  Future<IngredientCategoryEntity> call(
      IngredientCategoryEntity newCategory) async {
    return await _repository.createIngredientCategory(newCategory: newCategory);
  }
}
