import 'package:slagalica/features/app_state_init/domain/entities/game_entities/moj_broj_entity.dart';

class MojBrojModel extends MojBrojEntity {
  MojBrojModel({
    required List<int> smallNumbers,
    required int middleNumber,
    required int bigNumber,
    required int goal,
    required String playerOneExpression,
    required String playerOneExpressionResult,
    required String playerTwoExpression,
    required String playerTwoExpressionResult,
    required int turn,
    required String event,
  }) : super(
            smallNumbers: smallNumbers,
            middleNumber: middleNumber,
            bigNumber: bigNumber,
            goal: goal,
            playerOneExpression: playerOneExpression,
            playerOneExpressionResult: playerOneExpressionResult,
            playerTwoExpression: playerTwoExpression,
            playerTwoExpressionResult: playerTwoExpressionResult,
            turn: turn,
            event: event);

  factory MojBrojModel.fromJson(Map<String, dynamic> json) {
    return MojBrojModel(
      smallNumbers: List<int>.from(json['smallNumbers']),
      middleNumber: json['middleNumber'],
      bigNumber: json['bigNumber'],
      goal: json['goal'],
      playerOneExpression: json['playerOneExpression'],
      playerOneExpressionResult: json['playerOneExpressionResult'],
      playerTwoExpression: json['playerTwoExpression'],
      playerTwoExpressionResult: json['playerTwoExpressionResult'],
      turn: json['turn'],
      event: json['event'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'smallNumbers': smallNumbers,
      'middleNumber': middleNumber,
      'bigNumber': bigNumber,
      'goal': goal,
      'playerOneExpression': playerOneExpression,
      'playerOneExpressionResult': playerOneExpressionResult,
      'playerTwoExpression': playerTwoExpression,
      'playerTwoExpressionResult': playerTwoExpressionResult,
      'turn': turn,
      'event': event,
    };
  }

  factory MojBrojModel.empty() {
    return MojBrojModel(
      smallNumbers: [],
      middleNumber: 0,
      bigNumber: 0,
      goal: 0,
      playerOneExpression: '',
      playerOneExpressionResult: '',
      playerTwoExpression: '',
      playerTwoExpressionResult: '',
      turn: 1,
      event: 'initMojBroj',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MojBrojModel &&
          _comapreLists(this.smallNumbers, other.smallNumbers) &&
          this.middleNumber == other.middleNumber &&
          this.bigNumber == other.bigNumber &&
          this.goal == other.goal &&
          this.playerOneExpression == other.playerOneExpression &&
          this.playerOneExpressionResult == other.playerOneExpressionResult &&
          this.playerTwoExpression == other.playerTwoExpression &&
          this.playerTwoExpressionResult == other.playerTwoExpressionResult &&
          this.turn == other.turn &&
          this.event == other.event;

  bool compare(MojBrojModel other) {
    return this == other;
  }

  _comapreLists(List<int> list1, List<int> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }
}
