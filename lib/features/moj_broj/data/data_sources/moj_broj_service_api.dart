import 'package:slagalica/features/moj_broj/data/models/refactor_expression_model.dart';

class MojBrojServiceApi {
  RefactorExpressionModel refactorExpression(
      RefactorExpressionModel expression) {
    if (expression.index == 0) {
      expression.expression = _addSign(expression.expression, expression.param);
    } else {
      expression = _addNumber(expression);
    }

    return expression;
  }

  String reduceExpression(String expression) {
    if (expression.isEmpty) {
      return expression;
    }

    if ('+-*/()'.contains(expression[expression.length - 1])) {
      return expression.substring(0, expression.length - 1);
    }

    while (expression.isNotEmpty &&
        !'+-*/()'.contains(expression[expression.length - 1])) {
      expression = expression.substring(0, expression.length - 1);
    }

    return expression;
  }

  String _addSign(String expression, String sign) {
    if (expression.isEmpty) {
      return expression + sign;
    }

    if (sign == "(") {
      if (expression[expression.length - 1] == '+' ||
          expression[expression.length - 1] == '-' ||
          expression[expression.length - 1] == '*' ||
          expression[expression.length - 1] == '/' ||
          expression[expression.length - 1] == '(') {
        return expression + sign;
      } else {
        return expression;
      }
    }

    if (expression[expression.length - 1] == '+' ||
        expression[expression.length - 1] == '-' ||
        expression[expression.length - 1] == '*' ||
        expression[expression.length - 1] == '/') {
      return expression;
    }

    return expression + sign;
  }

  RefactorExpressionModel _addNumber(RefactorExpressionModel expression) {
    if (expression.expression.isEmpty) {
      expression.tapped.add(expression.index);
      expression.expression += expression.param;
      return expression;
    }

    if (expression.expression[expression.expression.length - 1] == '+' ||
        expression.expression[expression.expression.length - 1] == '-' ||
        expression.expression[expression.expression.length - 1] == '*' ||
        expression.expression[expression.expression.length - 1] == '/' ||
        expression.expression[expression.expression.length - 1] == '(' ||
        expression.expression[expression.expression.length - 1] == ')') {
      expression.expression += expression.param;
      expression.tapped.add(expression.index);
    }

    return expression;
  }
}
