import 'package:slagalica/core/resources/combination.dart';
import 'package:slagalica/features/app_state_init/domain/entities/game_entities/skocko_entity.dart';

class SkockoModel extends SkockoEntity {
  SkockoModel({
    required int turn,
    required List<List<int>> playerCombinations,
    required List<int> correct,
    required List<List<int>> playerGuesses,
    required int index,
    required List<int> oponnentCombination,
    required List<int> oponnentGuess,
    required bool over,
    required bool oponentTurn,
  }) : super(
          turn: turn,
          playerCombinations: playerCombinations,
          correct: correct,
          playerGuesses: playerGuesses,
          index: index,
          oponnentCombination: oponnentCombination,
          oponnentGuess: oponnentGuess,
          over: over,
          oponentTurn: oponentTurn,
        );

  factory SkockoModel.fromJson(Map<String, dynamic> json) {
    return SkockoModel(
      turn: json['turn'],
      playerCombinations: (json['playerCombinations'] as List)
          .map(
              (e) => (e as String).split(',').map((e) => int.parse(e)).toList())
          .toList(),
      correct: (json['correct'] as List).map((e) => e as int).toList(),
      playerGuesses: (json['playerGuesses'] as List)
          .map(
              (e) => (e as String).split(',').map((e) => int.parse(e)).toList())
          .toList(),
      index: json['index'],
      oponnentCombination:
          (json['oponnentCombination'] as List).map((e) => e as int).toList(),
      oponnentGuess:
          (json['oponnentGuess'] as List).map((e) => e as int).toList(),
      over: json['over'],
      oponentTurn: json['oponentTurn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'turn': turn,
      'playerCombinations': playerCombinations.map((e) => e.join(',')).toList(),
      'correct': correct,
      'playerGuesses': playerGuesses.map((e) => e.join(',')).toList(),
      'index': index,
      'oponnentCombination': oponnentCombination,
      'oponnentGuess': oponnentGuess,
      'over': over,
      'oponentTurn': oponentTurn,
    };
  }

  factory SkockoModel.empty() {
    return SkockoModel(
      turn: 1,
      playerCombinations: [
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
      ],
      correct: [],
      playerGuesses: [
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
      ],
      index: 0,
      oponnentCombination: [0, 0, 0, 0],
      oponnentGuess: [0, 0, 0, 0],
      over: false,
      oponentTurn: false,
    );
  }

  SkockoModel copyWith({
    int? turn,
    List<List<int>>? playerCombinations,
    List<int>? correct,
    List<List<int>>? playerGuesses,
    int? index,
    List<int>? oponnentCombination,
    List<int>? oponnentGuess,
    bool? over,
    bool? oponentTurn,
  }) {
    return SkockoModel(
      turn: turn ?? this.turn,
      playerCombinations: playerCombinations ?? this.playerCombinations,
      correct: correct ?? this.correct,
      playerGuesses: playerGuesses ?? this.playerGuesses,
      index: index ?? this.index,
      oponnentCombination: oponnentCombination ?? this.oponnentCombination,
      oponnentGuess: oponnentGuess ?? this.oponnentGuess,
      over: over ?? this.over,
      oponentTurn: oponentTurn ?? this.oponentTurn,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SkockoModel &&
          other.runtimeType == SkockoModel &&
          other.turn == turn &&
          _compareLists(other.correct, correct) &&
          _compareNestedLists(other.playerCombinations, playerCombinations) &&
          _compareNestedLists(other.playerGuesses, playerGuesses) &&
          other.index == index &&
          _compareLists(other.oponnentCombination, oponnentCombination) &&
          _compareLists(other.oponnentGuess, oponnentGuess) &&
          other.over == over &&
          other.oponentTurn == oponentTurn;

  bool compare(SkockoModel other) {
    return this == other;
  }

  bool _compareCombinations(List<Combination> list1, List<Combination> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }

  bool _compareNestedLists(List<List<int>> list1, List<List<int>> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (!_compareLists(list1[i], list2[i])) return false;
    }
    return true;
  }

  bool _compareLists(List<int> list1, List<int> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }
}
