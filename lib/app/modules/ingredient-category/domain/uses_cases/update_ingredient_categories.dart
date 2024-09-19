import '../../../../../core/clean-archi/clean_archi_base_components.dart';
import '../entities/ingredient_category_entity.dart';
import '../repositories/ingredient_category_repository.dart';

class UpdateIngredientCategories
    implements
        UseCase<List<IngredientCategoryEntity>,
            List<IngredientCategoryEntity>> {
  final IngredientCategoryRepository _repository;

  UpdateIngredientCategories(this._repository);

  @override
  Future<List<IngredientCategoryEntity>> call(
      List<IngredientCategoryEntity> updatedCategories) async {
    return await _repository.updateIngredientCategories(
        updatedCategories: updatedCategories);
  }
}
