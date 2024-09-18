import 'package:slagalica/features/app_state_init/domain/entities/game_entities/slagalica_entity.dart';

class SlagalicaModel extends SlagalicaEntity {
  SlagalicaModel({
    required List<String> letters,
    required String playerOneWord,
    required String playerTwoWord,
    required bool playerOneWordExists,
    required bool playerTwoWordExists,
    int turn = 1,
    String event = '',
  }) : super(
          letters: letters,
          playerOneWord: playerOneWord,
          playerTwoWord: playerTwoWord,
          playerOneWordExists: playerOneWordExists,
          playerTwoWordExists: playerTwoWordExists,
          turn: turn,
          event: event,
        );

  factory SlagalicaModel.fromJson(Map<String, dynamic> json) {
    return SlagalicaModel(
      letters: List<String>.from(json['letters']),
      playerOneWord: json['playerOneWord'],
      playerTwoWord: json['playerTwoWord'],
      playerOneWordExists: json['playerOneWordExists'],
      playerTwoWordExists: json['playerTwoWordExists'],
      turn: json['turn'],
      event: json['event'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'letters': letters,
      'playerOneWord': playerOneWord,
      'playerTwoWord': playerTwoWord,
      'playerOneWordExists': playerOneWordExists,
      'playerTwoWordExists': playerTwoWordExists,
      'turn': turn,
      'event': event,
    };
  }

  SlagalicaModel copyWith({
    List<String>? letters,
    String? playerOneWord,
    String? playerTwoWord,
    bool? playerOneWordExists,
    bool? playerTwoWordExists,
    int? turn,
    String? event,
  }) {
    return SlagalicaModel(
      letters: letters ?? this.letters,
      playerOneWord: playerOneWord ?? this.playerOneWord,
      playerTwoWord: playerTwoWord ?? this.playerTwoWord,
      playerOneWordExists: playerOneWordExists ?? this.playerOneWordExists,
      playerTwoWordExists: playerTwoWordExists ?? this.playerTwoWordExists,
      turn: turn ?? this.turn,
      event: event ?? this.event,
    );
  }

  factory SlagalicaModel.fromEntity(SlagalicaEntity entity) {
    return SlagalicaModel(
      letters: entity.letters,
      playerOneWord: entity.playerOneWord,
      playerTwoWord: entity.playerTwoWord,
      playerOneWordExists: entity.playerOneWordExists,
      playerTwoWordExists: entity.playerTwoWordExists,
      turn: entity.turn,
      event: entity.event,
    );
  }

  factory SlagalicaModel.empty() {
    return SlagalicaModel(
      letters: [],
      playerOneWord: '',
      playerTwoWord: '',
      playerOneWordExists: false,
      playerTwoWordExists: false,
      turn: 1,
      event: '',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SlagalicaModel &&
          runtimeType == other.runtimeType &&
          _listEquals(letters, other.letters) &&
          playerOneWord == other.playerOneWord &&
          playerTwoWord == other.playerTwoWord &&
          playerOneWordExists == other.playerOneWordExists &&
          playerTwoWordExists == other.playerTwoWordExists &&
          turn == other.turn &&
          event == other.event;

  @override
  int get hashCode =>
      letters.hashCode ^
      playerOneWord.hashCode ^
      playerTwoWord.hashCode ^
      playerOneWordExists.hashCode ^
      playerTwoWordExists.hashCode ^
      turn.hashCode ^
      event.hashCode;

  bool _listEquals<T>(List<T> list1, List<T> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }

  bool compare(SlagalicaModel slagalica) {
    return this == slagalica;
  }

  @override
  String toString() {
    return 'SlagalicaModel(letters: $letters, playerOneWord: $playerOneWord, playerTwoWord: $playerTwoWord, playerOneWordExists: $playerOneWordExists, playerTwoWordExists: $playerTwoWordExists, turn: $turn, event: $event)';
  }
}
