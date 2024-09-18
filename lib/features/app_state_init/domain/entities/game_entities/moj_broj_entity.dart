abstract class MojBrojEntity {
  List<int> smallNumbers;
  int middleNumber;
  int bigNumber;
  int goal;
  String playerOneExpression = '';
  String playerOneExpressionResult = '';
  String playerTwoExpression = '';
  String playerTwoExpressionResult = '';
  int turn = 1;
  String event;

  MojBrojEntity({
    required this.smallNumbers,
    required this.middleNumber,
    required this.bigNumber,
    required this.goal,
    required this.playerOneExpression,
    required this.playerOneExpressionResult,
    required this.playerTwoExpression,
    required this.playerTwoExpressionResult,
    required this.turn,
    required this.event,
  });
}
