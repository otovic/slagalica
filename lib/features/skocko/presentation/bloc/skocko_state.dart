part of 'skocko_bloc.dart';

abstract class SkockoState {
  const SkockoState();
}

class SkockoUninitialized extends SkockoState {
  SkockoUninitialized();
}

class SkockoInitialized extends SkockoState {
  final SkockoModel skocko;
  final int playerIndex;
  final List<int> combination;
  final List<List<int>> combinations;
  final int combinationIndex;
  final List<int> correctCombination;
  final List<List<int>> guesses;
  final List<int> oponnentCombinationLocal;
  final List<int> oponnentCombination;
  final List<int> oponnentGuess;
  final bool oponentTurn;

  SkockoInitialized({
    required this.skocko,
    required this.playerIndex,
    required this.combination,
    required this.combinations,
    required this.combinationIndex,
    required this.correctCombination,
    required this.guesses,
    required this.oponnentCombination,
    required this.oponnentCombinationLocal,
    required this.oponnentGuess,
    required this.oponentTurn,
  });
}
