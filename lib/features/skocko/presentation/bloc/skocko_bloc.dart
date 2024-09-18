library skocko_bloc;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slagalica/core/resources/combination.dart';
import 'package:slagalica/core/utils/game_timer.dart';
import 'package:slagalica/features/app_state_init/data/models/game_models/skocko_model.dart';
import 'package:slagalica/features/app_state_init/data/models/player_model.dart';
import 'package:slagalica/features/play_game/presentation/bloc/play_game_bloc.dart';
import 'package:slagalica/features/skocko/data/data_source/skocko_api_service.dart';
import 'package:slagalica/features/skocko/data/models/guess_combination_model.dart';
import 'package:slagalica/features/skocko/data/repositories/skocko_repository_implementation.dart';
import 'package:slagalica/features/skocko/domain/usecases/get_combination_usecase.dart';
import 'package:slagalica/features/skocko/domain/usecases/guess_combination_usecase.dart';

part "skocko_events.dart";
part "skocko_state.dart";

class SkockoBloc extends Bloc<SkockoEvent, SkockoState> {
  SkockoBloc({
    required SkockoModel skocko,
    required int playerIndex,
    required PlayGameBloc playGameBloc,
    required String roomID,
  }) : super(SkockoUninitialized()) {
    _skocko = skocko;
    _playerIndex = playerIndex;
    _playGameBloc = playGameBloc;
    _roomID = roomID;

    on<SkockoSyncDataEvent>(_syncData);
    on<SkockoInitCombinationEvent>(_initCombination);
    on<SkockoAddSignEvent>(_addSign);
    on<SkockoRemoveSignEvent>(_removeSign);
    on<SkockoSubmitCombinationEvent>(_submitCombination);
    on<SkockoEndGameCorrectEvent>(_endGame);
    on<SkockoStartTimerEvent>(_startTimer);
    on<SkockoRestartGameEvent>(_restartGame);
    on<SkockoSubmitOverEvent>(_submitOver);
    on<SkockoOponnentTurnEvent>(_oponentTurn);
    on<SkockoSubmitOponnentCombinationEvent>(_submitOponentCombination);

    SkockoRepositoryImplementation _skockoRepositoryImplementation =
        SkockoRepositoryImplementation(
      SkockoApiService(),
    );

    _getCombinationUseCase = GetCombinationUseCase(
      _skockoRepositoryImplementation,
    );
    _guessCombinationUseCase = GuessCombinationUseCase(
      _skockoRepositoryImplementation,
    );

    print("SkockoBloc initialized INIT");

    add(const SkockoSyncDataEvent());

    if (_skocko.turn == _playerIndex && _skocko.correct.isEmpty) {
      add(const SkockoInitCombinationEvent());
    }
  }

  late SkockoModel _skocko;
  late int _playerIndex;
  late PlayGameBloc _playGameBloc;
  late String _roomID;
  String _lastState = "";

  late final GetCombinationUseCase _getCombinationUseCase;
  late final GuessCombinationUseCase _guessCombinationUseCase;

  late PlayerModel _controlledPlayer;
  late PlayerModel _opponentPlayer;

  int _combinationIndex = 0;
  List<int> _correctCombination = [0, 0, 0, 0];
  List<int> _currentCombination = [0, 0, 0, 0];
  List<int> _localCombination = [0, 0, 0, 0];
  List<int> _oponentCombination = [0, 0, 0, 0];

  _default() {
    _lastState = "";
    _correctCombination = [0, 0, 0, 0];
    _combinationIndex = 0;
    _currentCombination = [0, 0, 0, 0];
  }

  _restartGame(SkockoRestartGameEvent event, Emitter<SkockoState> emit) {
    try {
      FirebaseFirestore.instance.collection('rooms').doc(_roomID).update({
        "skocko": SkockoModel.empty().copyWith(turn: 2),
      });
    } catch (e) {
      print("Error restarting game: $e");
    }
  }

  updatePlayerPressence(
      SkockoModel room, PlayerModel player1, PlayerModel player2) {
    if (_playerIndex == 1) {
      _controlledPlayer = player1;
      _opponentPlayer = player2;
    } else {
      _controlledPlayer = player2;
      _opponentPlayer = player1;
    }

    if (_opponentPlayer.ready == false) {
      if (_skocko.turn == _playerIndex) {
        FirebaseFirestore.instance.collection('rooms').doc(_roomID).update({});
      } else if (_skocko.turn == 2) {
        //TODO: Switch game
        print("Switch game");
      } else {
        add(const SkockoRestartGameEvent());
      }
    }
  }

  updateState(SkockoModel state, PlayerModel player1, PlayerModel player2) {
    if (state.turn != _skocko.turn && state.oponentTurn == false) {
      _default();
      if (state.turn == _playerIndex) {
        add(const SkockoInitCombinationEvent());
      }
    }
    _skocko = state;

    if (_playerIndex == 1) {
      _controlledPlayer = player1;
      _opponentPlayer = player2;
    } else {
      _controlledPlayer = player2;
      _opponentPlayer = player1;
    }

    add(const SkockoSyncDataEvent());
  }

  _syncData(SkockoSyncDataEvent event, Emitter<SkockoState> emit) {
    emit(
      SkockoInitialized(
        skocko: _skocko,
        playerIndex: _playerIndex,
        combination: _localCombination,
        combinations: _skocko.playerCombinations,
        combinationIndex: _skocko.index,
        correctCombination: _skocko.correct,
        guesses: _skocko.playerGuesses,
        oponnentCombination: _skocko.oponnentCombination,
        oponnentCombinationLocal: _oponentCombination,
        oponnentGuess: _skocko.oponnentGuess,
        oponentTurn: _skocko.oponentTurn,
      ),
    );
  }

  _initCombination(
      SkockoInitCombinationEvent event, Emitter<SkockoState> emit) {
    try {
      _correctCombination = _getCombinationUseCase.call();

      print("Initing combination EVENT");
      FirebaseFirestore.instance.collection('rooms').doc(_roomID).update({
        "skocko.correct": [
          _correctCombination[0],
          _correctCombination[1],
          _correctCombination[2],
          _correctCombination[3],
        ],
      });
    } catch (e) {
      print("Error initing combination: $e");
    }
  }

  _startTimer(SkockoStartTimerEvent event, Emitter<SkockoState> emit) {
    try {
      if (_lastState == "start") {
        return;
      }
      _lastState = "start";

      _playGameBloc.add(SetTimerEvent(GameTimer(
        "mainTimer",
        75,
        () {
          if (_skocko.turn == _playerIndex) {
            FirebaseFirestore.instance.collection('rooms').doc(_roomID).update({
              "skocko.oponentTurn": true,
              "turn": _playerIndex == 1 ? 2 : 1,
            });
          }
        },
      )));
    } catch (e) {
      print("Error starting timer: $e");
    }
  }

  _addSign(SkockoAddSignEvent event, Emitter<SkockoState> emit) {
    if (_skocko.oponentTurn && _skocko.turn != _playerIndex) {
      if (_oponentCombination[0] == 0) {
        _oponentCombination[0] = event.index;
      } else if (_oponentCombination[1] == 0) {
        _oponentCombination[1] = event.index;
      } else if (_oponentCombination[2] == 0) {
        _oponentCombination[2] = event.index;
      } else if (_oponentCombination[3] == 0) {
        _oponentCombination[3] = event.index;
      }
      add(const SkockoSyncDataEvent());
      return;
    } else {
      if (_skocko.over) return;
      if (_skocko.turn != _playerIndex) return;
      if (_localCombination[0] == 0) {
        _localCombination[0] = event.index;
      } else if (_localCombination[1] == 0) {
        _localCombination[1] = event.index;
      } else if (_localCombination[2] == 0) {
        _localCombination[2] = event.index;
      } else if (_localCombination[3] == 0) {
        _localCombination[3] = event.index;
      }

      add(const SkockoSyncDataEvent());
    }
  }

  _removeSign(SkockoRemoveSignEvent event, Emitter<SkockoState> emit) {
    if (_skocko.over) return;
    if (_skocko.turn != _playerIndex) return;
    if (_localCombination[3] != 0) {
      _localCombination[3] = 0;
    } else if (_localCombination[2] != 0) {
      _localCombination[2] = 0;
    } else if (_localCombination[1] != 0) {
      _localCombination[1] = 0;
    } else if (_localCombination[0] != 0) {
      _localCombination[0] = 0;
    }

    add(const SkockoSyncDataEvent());
  }

  _submitCombination(
      SkockoSubmitCombinationEvent event, Emitter<SkockoState> emit) {
    try {
      if (_localCombination.contains(0)) {
        print("Combination not complete");
        return;
      }

      // if (_skocko.oponentTurn) {
      //   List<int> oponnentGuess = _guessCombinationUseCase.call(
      //     GuessCombinationModel(
      //       combination: _localCombination,
      //       correct: _skocko.correct,
      //     ),
      //   );

      //   if (oponnentGuess[0] == 1 &&
      //       oponnentGuess[1] == 1 &&
      //       oponnentGuess[2] == 1 &&
      //       oponnentGuess[3] == 1) {
      //     FirebaseFirestore.instance.collection('rooms').doc(_roomID).update({
      //       "skocko.oponnentCombination": _localCombination,
      //       "skocko.oponnentGuess": oponnentGuess,
      //       "skocko.oponentTurn": false,
      //     });
      //     return;
      //   } else {
      //     FirebaseFirestore.instance.collection('rooms').doc(_roomID).update({
      //       "skocko.oponnentCombination": _localCombination,
      //       "skocko.oponnentGuess": oponnentGuess,
      //       "skocko.oponentTurn": false,
      //     });
      //   }
      // }

      List<int> result = _guessCombinationUseCase.call(
        GuessCombinationModel(
          combination: _localCombination,
          correct: _correctCombination,
        ),
      );

      _skocko.playerGuesses[_combinationIndex] = result;
      _skocko.playerCombinations[_combinationIndex] = _localCombination;
      _localCombination = [0, 0, 0, 0];

      if (result[0] == 1 &&
          result[1] == 1 &&
          result[2] == 1 &&
          result[3] == 1) {
        add(const SkockoEndGameCorrectEvent());
        return;
      }

      _combinationIndex++;

      if (_combinationIndex == 6) {
        FirebaseFirestore.instance.collection('rooms').doc(_roomID).update({
          "skocko.playerCombinations":
              _skocko.playerCombinations.map((e) => _listToString(e)).toList(),
          "skocko.playerGuesses":
              _skocko.playerGuesses.map((e) => _listToString(e)).toList(),
          "skocko.index": FieldValue.increment(1),
          "skocko.oponentTurn": true,
          "turn": _playerIndex == 1 ? 2 : 1,
        });
        return;
      }

      FirebaseFirestore.instance.collection('rooms').doc(_roomID).update({
        "skocko.playerCombinations":
            _skocko.playerCombinations.map((e) => _listToString(e)).toList(),
        "skocko.playerGuesses":
            _skocko.playerGuesses.map((e) => _listToString(e)).toList(),
        "skocko.index": FieldValue.increment(1),
      });
    } catch (e) {
      print("Error submitting combination: $e");
    }
  }

  _submitOponentCombination(
      SkockoSubmitOponnentCombinationEvent event, Emitter<SkockoState> emit) {
    try {
      if (_oponentCombination.contains(0)) {
        print("Combination not complete");
        return;
      }

      List<int> result = _guessCombinationUseCase.call(
        GuessCombinationModel(
          combination: _oponentCombination,
          correct: _skocko.correct,
        ),
      );

      print("RESULTING OPOENT GUESS: $result");

      if (result[0] == 1 &&
          result[1] == 1 &&
          result[2] == 1 &&
          result[3] == 1) {
        FirebaseFirestore.instance.collection('rooms').doc(_roomID).update({
          "skocko.oponnentCombination": _oponentCombination,
          "skocko.oponnentGuess": result,
          "skocko.oponentTurn": false,
          "skocko.over": true,
          "player${_playerIndex == 1 ? 1 : 2}.points": FieldValue.increment(10),
        });
        return;
      }

      FirebaseFirestore.instance.collection('rooms').doc(_roomID).update({
        "skocko.oponnentCombination": _oponentCombination,
        "skocko.oponnentGuess": result,
        "skocko.oponentTurn": false,
        "skocko.over": true,
      });

      return;
    } catch (e) {
      print("Error submitting oponent combination: $e");
    }
  }

  _endGame(SkockoEndGameCorrectEvent event, Emitter<SkockoState> emit) {
    try {
      if (_skocko.turn == _playerIndex) {
        int points = 0;
        if (_combinationIndex == 0 || _combinationIndex == 1) {
          points = 20;
        } else if (_combinationIndex == 2 || _combinationIndex == 3) {
          points = 15;
        } else if (_combinationIndex == 4 || _combinationIndex == 5) {
          points = 10;
        }

        FirebaseFirestore.instance.collection('rooms').doc(_roomID).update({
          "skocko.playerCombinations":
              _skocko.playerCombinations.map((e) => _listToString(e)).toList(),
          "skocko.playerGuesses":
              _skocko.playerGuesses.map((e) => _listToString(e)).toList(),
          "player${_playerIndex == 1 ? "1" : "2"}.points":
              FieldValue.increment(points),
          "skocko.index": FieldValue.increment(1),
          "skocko.over": true,
        });
      }
    } catch (e) {
      print("Error ending game: $e");
    }
  }

  _submitOver(SkockoSubmitOverEvent event, Emitter<SkockoState> emit) {
    if (_lastState == "submit") return;
    _lastState = "submit";

    _playGameBloc.add(SetTimerEvent(GameTimer(
      "submitTimer",
      7,
      () {
        if (_skocko.turn == _playerIndex && _skocko.turn != 2) {
          FirebaseFirestore.instance.collection('rooms').doc(_roomID).update({
            "skocko": SkockoModel.empty().copyWith(turn: 2).toJson(),
            "turn": _playerIndex == 1 ? 2 : 1,
          });
        }
      },
    )));
  }

  _oponentTurn(SkockoOponnentTurnEvent event, Emitter<SkockoState> emit) {
    try {
      if (_lastState == "oponent") return;
      _lastState = "oponent";
      _playGameBloc.add(SetTimerEvent(GameTimer(
        "oponentTimer",
        15,
        () {
          add(const SkockoSubmitOverEvent());
        },
      )));
    } catch (e) {
      print("Error oponent turn: ${e}");
    }
  }

  String _listToString(List<int> list) {
    return list.join(",");
  }
}
