part of 'slagalica_bloc.dart';

abstract class SlagalicaBlocState {
  const SlagalicaBlocState();
}

class SlagalicaBlocInitial extends SlagalicaBlocState {
  final SlagalicaModel slagalica;
  const SlagalicaBlocInitial(this.slagalica);
}

class SlagalicaLetterSelect extends SlagalicaBlocState {
  final SlagalicaModel slagalica;
  final List<String> letters;
  final int playerIndex;
  const SlagalicaLetterSelect(this.slagalica, this.letters, this.playerIndex);
}

class SlagalicaLettersSelected extends SlagalicaBlocState {
  final SlagalicaModel slagalica;
  final List<String> letters;
  final List<int> tapped;
  final int playerIndex;
  final String word;
  final int wordExists;
  final bool progress;
  const SlagalicaLettersSelected(this.slagalica, this.letters, this.tapped,
      this.playerIndex, this.word, this.wordExists, this.progress);
}

class SlagalicaWaitingForOponent extends SlagalicaBlocState {
  final SlagalicaModel slagalica;
  final int playerIndex;
  final String word;
  final bool wordExists;
  final List<String> letters;
  final List<int> tapped;
  const SlagalicaWaitingForOponent(this.slagalica, this.playerIndex, this.word,
      this.wordExists, this.letters, this.tapped);
}

class SlagalicaInitedState extends SlagalicaBlocState {
  final int playerIndex;
  final String word;
  final String wordLocal;
  final bool wordExists;
  final String opponentWord;
  final bool opponentWordExists;
  final List<String> letters;
  final List<String> generatedLetters;
  final List<int> tapped;
  final int turn;
  final bool progress = false;
  final int wordExistLocal;
  final int winner;
  const SlagalicaInitedState({
    required this.playerIndex,
    required this.word,
    required this.wordLocal,
    required this.wordExists,
    required this.opponentWord,
    required this.opponentWordExists,
    required this.letters,
    required this.generatedLetters,
    required this.tapped,
    required this.turn,
    required this.wordExistLocal,
    required this.winner,
  });

  @override
  String toString() {
    return 'SlagalicaInitedState { playerIndex: $playerIndex, word: $word, wordLocal: $wordLocal, wordExists: $wordExists, opponentWord: $opponentWord, opponentWordExists: $opponentWordExists, letters: $letters, generatedLetters: $generatedLetters, tapped: $tapped, turn: $turn, wordExistLocal: $wordExistLocal, winner: $winner }';
  }
}

class SlagalicaAwardPointsState extends SlagalicaBlocState {
  final SlagalicaModel slagalica;
  final int playerIndex;
  final List<String> letters;
  final String word;
  final bool wordExists;
  final String opponentWord;
  final bool opponentWordExists;
  final List<int> tapped;
  final int winner;
  const SlagalicaAwardPointsState(
    this.slagalica,
    this.playerIndex,
    this.letters,
    this.word,
    this.wordExists,
    this.opponentWord,
    this.opponentWordExists,
    this.tapped,
    this.winner,
  );
}
