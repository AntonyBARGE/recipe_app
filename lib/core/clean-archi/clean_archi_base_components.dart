import 'package:equatable/equatable.dart';

abstract class BaseEntity {}

abstract class BaseModel {}

abstract class Populator<M extends BaseModel, E extends BaseEntity> {
  void populate(M model, E entity);
}

abstract class Mapper {
  BaseEntity mapModelsToEntity(Map<BaseModel, Populator> populators);
  BaseModel mapEntityToModel(BaseEntity entity);
}

abstract class UseCase<Type, Params> {
  Future<Type?> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
