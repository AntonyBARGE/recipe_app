import '../../../../../core/clean-archi/clean_archi_base_components.dart';
import '../../data/models/ingredient_category_model.dart';
import '../entities/ingredient_category_entity.dart';

class IngredientCategoryMapper extends Mapper {
  /// Converts `Models` to `IngredientCategoryEntity`
  @override
  IngredientCategoryEntity mapModelsToEntity(
      Map<BaseModel, Populator> populators) {
    final entity = IngredientCategoryEntity(
      name: "name",
      id: "unknown",
      position: -1,
    );

    populators.forEach((model, populator) {
      populator.populate(model, entity);
    });

    return entity;
  }

  /// Converts `IngredientCategoryEntity` to `IngredientCategoryModel`
  @override
  IngredientCategoryModel mapEntityToModel(BaseEntity entity) {
    if (entity is IngredientCategoryEntity) {
      return IngredientCategoryModel(
        id: entity.id,
        name: entity.name,
        position: entity.position,
      );
    } else {
      throw ArgumentError('Invalid entity type');
    }
  }
}

class IngredientCategoryModelPopulator
    implements Populator<IngredientCategoryModel, IngredientCategoryEntity> {
  @override
  void populate(IngredientCategoryModel ingredientCategoryModel,
      IngredientCategoryEntity ingredientCategoryEntity) {
    ingredientCategoryEntity.name = ingredientCategoryModel.name;
    ingredientCategoryEntity.id = ingredientCategoryModel.id;
    ingredientCategoryEntity.position = ingredientCategoryModel.position;
  }
}
