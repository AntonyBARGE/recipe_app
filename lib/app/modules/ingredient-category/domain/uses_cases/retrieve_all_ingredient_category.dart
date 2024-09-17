import '../../../../../core/clean-archi/clean_archi_base_components.dart';
import '../entities/ingredient_category_entity.dart';
import '../repositories/ingredient_category_repository.dart';

class RetrieveIngredientCategories
    implements UseCase<List<IngredientCategoryEntity>, NoParams> {
  final IngredientCategoryRepository _repository;

  RetrieveIngredientCategories(this._repository);

  @override
  Future<List<IngredientCategoryEntity>> call(NoParams _) async {
    return await _repository.retrieveIngredientCategories();
  }
}
