import '../../../../../core/clean-archi/clean_archi_base_components.dart';
import '../repositories/ingredient_category_repository.dart';

class DeleteIngredientCategory implements UseCase<void, int> {
  final IngredientCategoryRepository _repository;

  DeleteIngredientCategory(this._repository);

  @override
  Future<void> call(int id) async {
    return await _repository.deleteIngredientCategory(categoryId: id);
  }
}
