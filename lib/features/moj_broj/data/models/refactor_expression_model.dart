import 'package:slagalica/features/moj_broj/domain/entities/refactor_expression_entity.dart';

class RefactorExpressionModel extends RefactorExpressionEntity {
  RefactorExpressionModel({
    required String expression,
    required List<int> tapped,
    required String param,
    required int index,
  }) : super(
            expression: expression, tapped: tapped, index: index, param: param);
}
