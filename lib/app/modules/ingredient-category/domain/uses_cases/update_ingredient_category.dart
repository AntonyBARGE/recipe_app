import '../../../../../core/clean-archi/clean_archi_base_components.dart';
import '../entities/ingredient_category_entity.dart';
import '../repositories/ingredient_category_repository.dart';

class UpdateIngredientCategory
    implements UseCase<void, IngredientCategoryEntity> {
  final IngredientCategoryRepository _repository;

  UpdateIngredientCategory(this._repository);

  @override
  Future<void> call(IngredientCategoryEntity updatedCategory) async {
    return await _repository.updateIngredientCategory(
        updatedCategory: updatedCategory);
  }
}
