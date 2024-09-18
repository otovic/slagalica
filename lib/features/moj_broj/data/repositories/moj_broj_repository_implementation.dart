import 'package:slagalica/features/moj_broj/data/data_sources/moj_broj_service_api.dart';
import 'package:slagalica/features/moj_broj/data/models/refactor_expression_model.dart';
import 'package:slagalica/features/moj_broj/domain/repositories/moj_broj_repository.dart';

class MojBrojRepositoryImplementation extends MojBrojRepository {
  final MojBrojServiceApi _serviceApi = MojBrojServiceApi();

  @override
  RefactorExpressionModel refactorExpression(
      RefactorExpressionModel expression) {
    return _serviceApi.refactorExpression(expression);
  }

  @override
  String reduceExpression(String expression) {
    return _serviceApi.reduceExpression(expression);
  }
}
