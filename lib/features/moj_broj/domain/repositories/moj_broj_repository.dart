import 'package:slagalica/features/moj_broj/data/models/refactor_expression_model.dart';

abstract class MojBrojRepository {
  RefactorExpressionModel refactorExpression(
      RefactorExpressionModel expression);

  String reduceExpression(String expression);
}
