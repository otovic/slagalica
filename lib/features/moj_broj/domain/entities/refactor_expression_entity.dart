abstract class RefactorExpressionEntity {
  String expression;
  List<int> tapped;
  final String param;
  final int index;

  RefactorExpressionEntity({
    required this.expression,
    required this.tapped,
    required this.param,
    required this.index,
  });
}
