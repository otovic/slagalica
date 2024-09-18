import 'package:slagalica/core/resources/combination.dart';
import 'package:slagalica/features/app_state_init/data/models/game_models/skocko_model.dart';

abstract class SkockoEntity {
  int turn;
  List<List<int>> playerCombinations = [];
  List<int> correct = [];
  List<List<int>> playerGuesses = [];
  int index = 0;
  List<int> oponnentCombination = [];
  List<int> oponnentGuess = [];
  bool over = false;
  bool oponentTurn = false;

  SkockoEntity({
    required this.turn,
    required this.playerCombinations,
    required this.correct,
    required this.playerGuesses,
    required this.index,
    required this.oponnentGuess,
    required this.oponnentCombination,
    required this.over,
    required this.oponentTurn,
  });
}
