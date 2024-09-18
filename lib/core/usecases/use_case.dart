abstract class UseCaseBase {
  const UseCaseBase();
}

abstract class UseCaseWithParams<Type, Params> extends UseCaseBase {
  Future<Type> call(Params params);
}

abstract class UseCaseNoParams<Type> extends UseCaseBase {
  Future<Type> call();
}

class NoParams {
  NoParams();
}

abstract class UseCaseNoParamsSync<Type> extends UseCaseBase {
  Type call();
}

abstract class UseCaseWithParamsSync<Type, Params> extends UseCaseBase {
  Type call(Params params);
}
