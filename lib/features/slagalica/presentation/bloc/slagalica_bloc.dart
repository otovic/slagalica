library slagalica_bloc;

import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slagalica/core/utils/game_timer.dart';
import 'package:slagalica/features/app_state_init/data/models/game_models/slagalica_model.dart';
import 'package:slagalica/features/app_state_init/data/models/game_room_model.dart';
import 'package:slagalica/features/app_state_init/data/models/player_model.dart';
import 'package:slagalica/features/play_game/presentation/bloc/play_game_bloc.dart';
import 'package:slagalica/features/slagalica/data/repositories/slagalica_repository_implementation.dart';
import 'package:slagalica/features/slagalica/data/sources/slagalica_api_service.dart';
import 'package:slagalica/features/slagalica/domain/usecases/generate_letters_usecase.dart';
import 'package:slagalica/features/slagalica/domain/usecases/get_word_length.dart';

part 'slagalica_bloc_event.dart';
part 'slagalica_bloc_state.dart';

class SlagalicaBloc extends Bloc<SlagalicaBlocEvent, SlagalicaBlocState> {
  final SlagalicaRepositoryImplementation _repository =
      SlagalicaRepositoryImplementation(SlagalicaApiService());
  late GenerateLettersUsecase _generateLettersUsecase;
  late GetWordLengthUseCase _getWordLengthUseCase;

  late PlayerModel controlledPlayer;
  late PlayerModel oponentPlayer;

  final int playerIndex;
  SlagalicaModel slagalica;
  final String roomId;

  PlayGameBloc playGameBloc;

  List<String> letters = [];
  String word = "";
  String commitedWord = "";
  String opponentWord = "";
  List<int> tapped = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  List<int> lettersByIndex = [];
  bool committed = false;
  List<String> existingWords = [];
  List<String> nonExistingWords = [];
  String lastState = "";
  Timer? selectLettersTimer;
  int wordExistsLocal = 0;
  Timer? _checkExistsTimer;

  SlagalicaBloc(
      this.slagalica, this.playerIndex, this.playGameBloc, this.roomId)
      : super(SlagalicaBlocInitial(slagalica)) {
    on<SlagalicaLetterSelectEvent>(
        (event, emit) => _selectLetters(event, emit));
    on<SlagalicaLettersSelectedEvent>(_lettersSelected);
    on<SlagalicaStopLettersEvent>(
        (event, emit) => _stopLetterSelect(event, emit));
    on<SlagalicaAddLetterEvent>((event, emit) => _addLetter(event, emit));
    on<SlagalicaRemoveLetterEvent>(_removeLetter);
    on<SlagalicaAwardPointsEvent>((event, emit) => _awardPoints(event, emit));
    on<SlagalicaCommitWordEvent>((event, emit) => _commitWord(event, emit));
    on<SlagalicaCheckExistsEvent>((event, emit) => _checkExists(event, emit));
    on<SlagalicaRestartGameEvent>(_restartGame);
    on<SlagalicaSyncEvent>((event, emit) => _sync(event, emit));
    on<SlagalicaGenerateLettersEvent>(
        (event, emit) => _generateLetters(event, emit));

    _generateLettersUsecase = GenerateLettersUsecase(_repository);
    _getWordLengthUseCase = GetWordLengthUseCase(_repository);

    add(
      SlagalicaSyncEvent(
          playerIndex: playerIndex,
          word: commitedWord,
          wordLocal: word,
          wordExists: false,
          opponentWord: opponentWord,
          opponentWordExists: false,
          letters: letters,
          generatedLetters: [],
          tapped: tapped,
          turn: slagalica.turn,
          wordExistLocal: wordExistsLocal,
          winner: 0),
    );
  }

  updatePlayerPressence(
      GameRoomModel room, PlayerModel player1, PlayerModel player2) {
    if (playerIndex == 1) {
      if (player2.ready == false && slagalica.turn == 2) {
        print("GAME OVER, CHANGE GAME");
        return;
      }
      if (player2.ready == false && slagalica.turn == 1) {
        print("AUTO COMMITING DISCONNECTED");
        FirebaseFirestore.instance.collection('rooms').doc(roomId).update({
          "slagalica.playerTwoWord": "mty",
          "slagalica.playerTwoWordExists": false,
        });
        return;
      }
    } else {
      if (player1.ready == false && slagalica.turn == 1) {
        print("RESTARTING GAME DISCONNECTED");
        add(const SlagalicaRestartGameEvent());
        return;
      }
      if (player1.ready == false && slagalica.turn == 2) {
        print("AUTO COMMITING DISCONNECTED");
        FirebaseFirestore.instance.collection('rooms').doc(roomId).update({
          "slagalica.playerOneWord": "mty",
          "slagalica.playerOneWordExists": false,
        });
        return;
      }
    }
  }

  updateState(SlagalicaModel state, PlayerModel player1, PlayerModel player2) {
    slagalica = state;

    if (playerIndex == 1) {
      controlledPlayer = player1;
      oponentPlayer = player2;
      opponentWord = slagalica.playerTwoWord;
      commitedWord = slagalica.playerOneWord;
      letters = slagalica.letters;
    } else {
      controlledPlayer = player2;
      oponentPlayer = player1;
      opponentWord = slagalica.playerOneWord;
      commitedWord = slagalica.playerTwoWord;
      letters = slagalica.letters;
    }

    if (slagalica.event == "initSlagalica") {
      _default();
      add(
        SlagalicaSyncEvent(
            playerIndex: playerIndex,
            word: commitedWord,
            wordLocal: word,
            wordExists: false,
            opponentWord: opponentWord,
            opponentWordExists: false,
            generatedLetters: _generateLettersUsecase.call(),
            letters: [],
            tapped: tapped,
            turn: slagalica.turn,
            wordExistLocal: wordExistsLocal,
            winner: 0),
      );
    }

    if (state is SlagalicaInitedState) {
      var current = state as SlagalicaInitedState;

      add(
        SlagalicaSyncEvent(
            playerIndex: playerIndex,
            word: commitedWord,
            wordLocal: current.word,
            wordExists: current.wordExists,
            opponentWord: opponentWord,
            opponentWordExists: current.opponentWordExists,
            generatedLetters: [],
            letters: slagalica.letters,
            tapped: tapped,
            turn: slagalica.turn,
            wordExistLocal: wordExistsLocal,
            winner: current.winner),
      );
    } else {
      add(
        SlagalicaSyncEvent(
            playerIndex: playerIndex,
            word: commitedWord,
            wordLocal: word,
            wordExists: false,
            opponentWord: opponentWord,
            opponentWordExists: false,
            generatedLetters: [],
            letters: slagalica.letters,
            tapped: tapped,
            turn: slagalica.turn,
            wordExistLocal: wordExistsLocal,
            winner: 0),
      );
    }
  }

  _sync(SlagalicaSyncEvent event, Emitter<SlagalicaBlocState> emit) {
    emit(SlagalicaInitedState(
      playerIndex: event.playerIndex,
      word: event.word,
      wordLocal: event.wordLocal,
      wordExists: event.wordExists,
      opponentWord: event.opponentWord,
      opponentWordExists: event.opponentWordExists,
      generatedLetters: event.generatedLetters,
      letters: event.letters,
      tapped: tapped,
      turn: event.turn,
      wordExistLocal: event.wordExistLocal,
      winner: 0,
    ));
  }

  _restartGame(
      SlagalicaRestartGameEvent event, Emitter<SlagalicaBlocState> emit) async {
    try {
      _default();

      await Future.delayed(const Duration(seconds: 1));

      FirebaseFirestore.instance.collection('rooms').doc(roomId).update({
        "slagalica.event": "initSlagalica",
        "slagalica.letters": [],
        "slagalica.playerOneWord": "",
        "slagalica.playerTwoWord": "",
        "slagalica.playerOneWordExists": false,
        "slagalica.playerTwoWordExists": false,
        "slagalica.turn": playerIndex
      });
    } catch (e) {
      print(e);
    }
  }

  _default() {
    letters = [];
    word = "";
    commitedWord = "";
    opponentWord = "";
    tapped = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    lettersByIndex = [];
    committed = false;
    existingWords = [];
    nonExistingWords = [];
    lastState = "";
    selectLettersTimer;
    wordExistsLocal = 0;
    _checkExistsTimer = null;
  }

  _selectLetters(SlagalicaLetterSelectEvent event,
      Emitter<SlagalicaBlocState> emit) async {
    if (lastState == "selectLetters") return;
    lastState = "selectLetters";

    playGameBloc.add(SetTimerEvent(GameTimer(
      "selectLetters",
      6,
      () {
        if (slagalica.turn == playerIndex) {
          add(const SlagalicaStopLettersEvent());
        }
      },
    )));

    selectLettersTimer =
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
      add(const SlagalicaGenerateLettersEvent());
    });
  }

  _generateLetters(
      SlagalicaGenerateLettersEvent event, Emitter<SlagalicaBlocState> emit) {
    var genLetters = _generateLettersUsecase.call();
    emit(
      SlagalicaInitedState(
          playerIndex: playerIndex,
          word: commitedWord,
          wordLocal: word,
          wordExists: false,
          opponentWord: opponentWord,
          opponentWordExists: false,
          generatedLetters: genLetters,
          letters: letters,
          tapped: tapped,
          turn: slagalica.turn,
          wordExistLocal: wordExistsLocal,
          winner: 0),
    );
  }

  _stopLetterSelect(
      SlagalicaStopLettersEvent event, Emitter<SlagalicaBlocState> emit) {
    selectLettersTimer?.cancel();
    selectLettersTimer = null;

    if (letters.isNotEmpty) return;

    SlagalicaInitedState currentState = state as SlagalicaInitedState;
    FirebaseFirestore.instance.collection('rooms').doc(roomId).update({
      "slagalica.event": "slagalicaLettersSelected",
      "slagalica.letters": currentState.generatedLetters,
    });
  }

  _lettersSelected(SlagalicaLettersSelectedEvent event,
      Emitter<SlagalicaBlocState> emit) async {
    if (lastState == "lettersSelected") return;
    lastState = "lettersSelected";

    selectLettersTimer?.cancel();
    selectLettersTimer = null;

    playGameBloc.add(SetTimerEvent(GameTimer(
      "selectWord",
      60,
      () {
        add(const SlagalicaCommitWordEvent());
      },
    )));
  }

  _addLetter(
      SlagalicaAddLetterEvent event, Emitter<SlagalicaBlocState> emit) async {
    if (committed) return;
    word += event.letter;
    tapped[event.index] = 1;
    lettersByIndex.add(event.index);
    wordExistsLocal = 1;

    emit(SlagalicaInitedState(
      playerIndex: playerIndex,
      wordLocal: word,
      word: commitedWord,
      wordExists: false,
      opponentWord: opponentWord,
      opponentWordExists: false,
      generatedLetters: [],
      letters: letters,
      tapped: tapped,
      turn: slagalica.turn,
      wordExistLocal: wordExistsLocal,
      winner: 0,
    ));

    add(const SlagalicaCheckExistsEvent());
  }

  _removeLetter(
      SlagalicaRemoveLetterEvent event, Emitter<SlagalicaBlocState> emit) {
    if (word.isEmpty) return;
    int index = lettersByIndex.last;

    if (slagalica.letters[index].length > 1) {
      word = word.substring(0, word.length - 2);
    } else {
      word = word.substring(0, word.length - 1);
    }

    tapped[index] = 0;
    lettersByIndex.remove(index);
    wordExistsLocal = 1;

    emit(SlagalicaInitedState(
      playerIndex: playerIndex,
      word: commitedWord,
      wordExists: false,
      wordLocal: word,
      opponentWord: opponentWord,
      opponentWordExists: false,
      generatedLetters: [],
      letters: slagalica.letters,
      tapped: tapped,
      turn: slagalica.turn,
      wordExistLocal: wordExistsLocal,
      winner: 0,
    ));

    add(const SlagalicaCheckExistsEvent());
  }

  _checkExists(
      SlagalicaCheckExistsEvent event, Emitter<SlagalicaBlocState> emit) async {
    try {
      if (existingWords.contains(word)) {
        if (state is SlagalicaLettersSelected) {
          wordExistsLocal = 2;
          emit(SlagalicaInitedState(
            playerIndex: playerIndex,
            word: commitedWord,
            wordLocal: word,
            wordExists: true,
            opponentWord: opponentWord,
            opponentWordExists: false,
            generatedLetters: [],
            letters: slagalica.letters,
            tapped: tapped,
            turn: slagalica.turn,
            wordExistLocal: wordExistsLocal,
            winner: 0,
          ));
        }
        return;
      } else if (nonExistingWords.contains(word)) {
        if (state is SlagalicaLettersSelected) {
          wordExistsLocal = 3;
          emit(SlagalicaInitedState(
            playerIndex: playerIndex,
            word: commitedWord,
            wordLocal: word,
            wordExists: true,
            opponentWord: opponentWord,
            opponentWordExists: false,
            generatedLetters: [],
            letters: slagalica.letters,
            tapped: tapped,
            turn: slagalica.turn,
            wordExistLocal: wordExistsLocal,
            winner: 0,
          ));
        }
        return;
      }

      _checkExistsTimer?.cancel();
      _checkExistsTimer =
          Timer.periodic(const Duration(seconds: 2), (timer) async {
        if (word.isEmpty) return;
        if (playerIndex == 1) {
          if (slagalica.playerOneWord.isEmpty) {
            if ((await FirebaseFirestore.instance
                    .collection('words')
                    .doc(word)
                    .get())
                .exists) {
              wordExistsLocal = 2;
              if (!existingWords.contains(word)) {
                existingWords.add(word);
              }
            } else {
              wordExistsLocal = 3;
              if (!nonExistingWords.contains(word)) {
                nonExistingWords.add(word);
              }
            }
          }
        } else {
          if (slagalica.playerTwoWord.isEmpty) {
            if ((await FirebaseFirestore.instance
                    .collection('words')
                    .doc(word)
                    .get())
                .exists) {
              wordExistsLocal = 2;
              if (!existingWords.contains(word)) {
                existingWords.add(word);
              }
            } else {
              wordExistsLocal = 3;
              if (!nonExistingWords.contains(word)) {
                nonExistingWords.add(word);
              }
            }
          }
        }

        add(
          SlagalicaSyncEvent(
              playerIndex: playerIndex,
              word: commitedWord,
              wordLocal: word,
              wordExists: false,
              opponentWord: opponentWord,
              opponentWordExists: false,
              letters: letters,
              generatedLetters: [],
              tapped: tapped,
              turn: slagalica.turn,
              wordExistLocal: wordExistsLocal,
              winner: 0),
        );

        _checkExistsTimer?.cancel();
      });
    } catch (e) {
      print("Error checking if word exists: $e");
    }
  }

  _commitWord(
      SlagalicaCommitWordEvent event, Emitter<SlagalicaBlocState> emit) async {
    try {
      if (committed) return;
      committed = true;
      _checkExistsTimer?.cancel();

      if (playerIndex == 1) {
        if (word.isEmpty) {
          word = "mty";

          FirebaseFirestore.instance.collection('rooms').doc(roomId).update({
            "slagalica.event": "commitWord$playerIndex",
            "slagalica.playerOneWord": "mty",
            "slagalica.playerOneWordExists": false
          });
        } else {
          if ((await FirebaseFirestore.instance
                  .collection('words')
                  .doc(word)
                  .get())
              .exists) {
            FirebaseFirestore.instance.collection('rooms').doc(roomId).update({
              "slagalica.event": "commitWord$playerIndex",
              "slagalica.playerOneWord": word,
              "slagalica.playerOneWordExists": true
            });
          } else {
            word = "mty";
            FirebaseFirestore.instance.collection('rooms').doc(roomId).update({
              "slagalica.event": "commitWord$playerIndex",
              "slagalica.playerOneWord": "mty",
              "slagalica.playerOneWordExists": false
            });
          }
        }
      } else {
        if (word.isEmpty) {
          word = "mty";
          FirebaseFirestore.instance.collection('rooms').doc(roomId).update({
            "slagalica.event": "commitWord$playerIndex",
            "slagalica.playerTwoWord": "mty",
            "slagalica.playerTwoWordExists": false
          });
        } else {
          if ((await FirebaseFirestore.instance
                  .collection('words')
                  .doc(word)
                  .get())
              .exists) {
            FirebaseFirestore.instance.collection('rooms').doc(roomId).update({
              "slagalica.event": "commitWord$playerIndex",
              "slagalica.playerTwoWord": word,
              "slagalica.playerTwoWordExists": true
            });
          } else {
            word = "mty";
            FirebaseFirestore.instance.collection('rooms').doc(roomId).update({
              "slagalica.event": "commitWord$playerIndex",
              "slagalica.playerTwoWord": "mty",
              "slagalica.playerTwoWordExists": false
            });
          }
        }
      }

      if (oponentPlayer.ready == false) {
        if (playerIndex == 1) {
          FirebaseFirestore.instance.collection('rooms').doc(roomId).update({
            "slagalica.playerTwoWord": "mty",
            "slagalica.playerTwoWordExists": false,
          });
        } else {
          FirebaseFirestore.instance.collection('rooms').doc(roomId).update({
            "slagalica.playerOneWord": "mty",
            "slagalica.playerOneWordExists": false,
          });
        }
      }
    } catch (e) {
      emit(SlagalicaInitedState(
        playerIndex: playerIndex,
        word: commitedWord,
        wordLocal: word,
        wordExists: false,
        opponentWord: opponentWord,
        opponentWordExists: false,
        generatedLetters: [],
        letters: letters,
        tapped: tapped,
        turn: slagalica.turn,
        wordExistLocal: wordExistsLocal,
        winner: 0,
      ));
      print(e);
    }
  }

  _awardPoints(
      SlagalicaAwardPointsEvent event, Emitter<SlagalicaBlocState> emit) async {
    try {
      if (lastState == "awardPoints") return;
      lastState = "awardPoints";

      int winner = 0;

      if (slagalica.playerOneWord == "mty" &&
          slagalica.playerTwoWord == "mty") {
        word = "NEMA REČ";
        opponentWord = "NEMA REČ";
      } else if (slagalica.playerOneWord != "mty" &&
          slagalica.playerTwoWord != "mty") {
        if (_getWordLengthUseCase(slagalica.playerOneWord) >
            _getWordLengthUseCase(slagalica.playerTwoWord)) {
          winner = 1;
        } else if (_getWordLengthUseCase(slagalica.playerOneWord) ==
                _getWordLengthUseCase(slagalica.playerTwoWord) &&
            slagalica.turn == 1) {
          winner = 1;
        }
      } else if (slagalica.playerTwoWord != "mty") {
        word = "NEMA REČ";
        winner = 2;
      } else {
        opponentWord = "NEMA REČ";
        winner = 1;
      }

      emit(SlagalicaInitedState(
        playerIndex: playerIndex,
        word: commitedWord,
        wordLocal: word,
        wordExists: slagalica.playerOneWordExists,
        opponentWord: opponentWord,
        opponentWordExists: slagalica.playerTwoWordExists,
        generatedLetters: [],
        letters: letters,
        tapped: tapped,
        turn: slagalica.turn,
        wordExistLocal: wordExistsLocal,
        winner: winner,
      ));

      if (playerIndex == slagalica.turn) {
        if (winner == 1) {
          int length = _getWordLengthUseCase.call(slagalica.playerOneWord);
          FirebaseFirestore.instance.collection('rooms').doc(roomId).update({
            "player1.points": FieldValue.increment(length),
          });
        } else if (winner == 2) {
          int length = _getWordLengthUseCase.call(slagalica.playerTwoWord);
          FirebaseFirestore.instance.collection('rooms').doc(roomId).update({
            "player2.points": FieldValue.increment(length),
          });
        }
      }

      playGameBloc.add(SetTimerEvent(GameTimer(
        "awardPoints",
        5,
        () {
          if (slagalica.turn == 2) {
            print("GAME OVER");
            return;
          }

          if (oponentPlayer.ready == false) {
            print("GAME OVER, CAN SWITCH GAME NOW");
            return;
          } else {
            if (slagalica.turn == playerIndex) {
              FirebaseFirestore.instance
                  .collection('rooms')
                  .doc(roomId)
                  .update({
                "slagalica.event": "initSlagalica",
                "slagalica.letters": [],
                "slagalica.playerOneWord": "",
                "slagalica.playerTwoWord": "",
                "slagalica.playerOneWordExists": false,
                "slagalica.playerTwoWordExists": false,
                "slagalica.turn": slagalica.turn == 1 ? 2 : 1,
                "turn": slagalica.turn == 1 ? 2 : 1
              });
            }
          }
        },
      )));
    } catch (e) {
      print(e);
    }
  }
}
