part of 'slagalica_bloc.dart';

abstract class SlagalicaBlocEvent {
  const SlagalicaBlocEvent();
}

class SlagalicaInitGameEvent extends SlagalicaBlocEvent {
  const SlagalicaInitGameEvent();
}

class SlagalicaLetterSelectEvent extends SlagalicaBlocEvent {
  const SlagalicaLetterSelectEvent();
}

class SlagalicaLettersSelectedEvent extends SlagalicaBlocEvent {
  const SlagalicaLettersSelectedEvent();
}

class SlagalicaStopLettersEvent extends SlagalicaBlocEvent {
  const SlagalicaStopLettersEvent();
}

class SlagalicaAddLetterEvent extends SlagalicaBlocEvent {
  final String letter;
  final int index;
  const SlagalicaAddLetterEvent(this.letter, this.index);
}

class SlagalicaRemoveLetterEvent extends SlagalicaBlocEvent {
  const SlagalicaRemoveLetterEvent();
}

class SlagalicaAwardPointsEvent extends SlagalicaBlocEvent {
  const SlagalicaAwardPointsEvent();
}

class SlagalicaCommitWordEvent extends SlagalicaBlocEvent {
  const SlagalicaCommitWordEvent();
}

class SlagalicaSyncStateEvent extends SlagalicaBlocEvent {
  const SlagalicaSyncStateEvent();
}

class SlagalicaCheckExistsEvent extends SlagalicaBlocEvent {
  const SlagalicaCheckExistsEvent();
}

class SlagalicaWaitingForOpponentEvent extends SlagalicaBlocEvent {
  const SlagalicaWaitingForOpponentEvent();
}

class SlagalicaPlayerDisconnectedEvent extends SlagalicaBlocEvent {
  const SlagalicaPlayerDisconnectedEvent();
}

class SlagalicaRestartGameEvent extends SlagalicaBlocEvent {
  const SlagalicaRestartGameEvent();
}

class SlagalicaGenerateLettersEvent extends SlagalicaBlocEvent {
  const SlagalicaGenerateLettersEvent();
}

class SlagalicaSyncEvent extends SlagalicaBlocEvent {
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
  final int wordExistLocal;
  final int winner;
  const SlagalicaSyncEvent({
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
}
