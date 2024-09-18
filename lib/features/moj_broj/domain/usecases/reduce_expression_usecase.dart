import 'package:slagalica/core/usecases/use_case.dart';
import 'package:slagalica/features/moj_broj/data/repositories/moj_broj_repository_implementation.dart';

class ReduceExpressionUsecase extends UseCaseWithParamsSync<String, String> {
  MojBrojRepositoryImplementation _repository =
      MojBrojRepositoryImplementation();

  @override
  String call(String expression) {
    return _repository.reduceExpression(expression);
  }
}
