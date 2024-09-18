import 'package:slagalica/features/app_state_init/data/models/game_models/moj_broj_model.dart';

abstract class MojBrojState {
  const MojBrojState();
}

class MojBrojInitial extends MojBrojState {
  const MojBrojInitial();
}

class MojBrojInitedState extends MojBrojState {
  final MojBrojModel mojBroj;
  final String controlledPlayerExpression;
  final String opponentPlayerExpression;
  final List<int> localSmallNumbers;
  final int localMiddleNumber;
  final int localBigNumber;
  final int localGoal;
  final int playerIndex;
  final String localExpression;
  final List<int> clickedNumbers;
  final String result;
  final int winner;

  const MojBrojInitedState({
    required this.mojBroj,
    required this.controlledPlayerExpression,
    required this.opponentPlayerExpression,
    required this.localSmallNumbers,
    required this.localMiddleNumber,
    required this.localBigNumber,
    required this.localGoal,
    required this.playerIndex,
    required this.localExpression,
    required this.clickedNumbers,
    required this.result,
    required this.winner,
  });
}
