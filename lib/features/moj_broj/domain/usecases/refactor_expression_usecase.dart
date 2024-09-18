import 'package:slagalica/core/usecases/use_case.dart';
import 'package:slagalica/features/moj_broj/data/models/refactor_expression_model.dart';
import 'package:slagalica/features/moj_broj/data/repositories/moj_broj_repository_implementation.dart';

class RefactorExpressionUseCase extends UseCaseWithParamsSync<
    RefactorExpressionModel, RefactorExpressionModel> {
  final MojBrojRepositoryImplementation _repository =
      MojBrojRepositoryImplementation();

  @override
  RefactorExpressionModel call(RefactorExpressionModel expression) {
    return _repository.refactorExpression(expression);
  }
}
