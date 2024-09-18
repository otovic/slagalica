import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slagalica/core/utils/game_timer.dart';
import 'package:slagalica/features/app_state_init/data/models/game_models/moj_broj_model.dart';
import 'package:slagalica/features/app_state_init/data/models/game_room_model.dart';
import 'package:slagalica/features/app_state_init/data/models/player_model.dart';
import 'package:slagalica/features/moj_broj/data/models/refactor_expression_model.dart';
import 'package:slagalica/features/moj_broj/domain/usecases/reduce_expression_usecase.dart';
import 'package:slagalica/features/moj_broj/domain/usecases/refactor_expression_usecase.dart';
import 'package:slagalica/features/moj_broj/presentation/bloc/moj_broj_event.dart';
import 'package:slagalica/features/moj_broj/presentation/bloc/moj_broj_state.dart';
import 'package:slagalica/features/play_game/presentation/bloc/play_game_bloc.dart';
import 'package:expressions/expressions.dart';

class MojBrojBloc extends Bloc<MojBrojEvent, MojBrojState> {
  MojBrojModel mojBroj;
  RefactorExpressionUseCase _refactorExpressionUseCase =
      RefactorExpressionUseCase();
  ReduceExpressionUsecase _reduceExpressionUsecase = ReduceExpressionUsecase();

  PlayGameBloc playGameBloc;
  int playerIndex;
  final String roomID;

  late PlayerModel controlledPlayer;
  late PlayerModel opponentPlayer;
  final List<int> possibleMiddleNumbers = [10, 15, 20, 25];
  final List<int> possibleBigNumbers = [50, 75, 100];

  String localExpression = "";

  List<int> localSmallNumbers = [0, 0, 0, 0];
  int localMiddleNumber = 0;
  int localBigNumber = 0;
  int localGoal = 0;
  Timer? generateNumbersTimer;
  String result = "";

  String lastState = "";
  List<int> clickedNumbers = [];
  int winner = 0;

  MojBrojBloc(
      {required this.mojBroj,
      required this.playGameBloc,
      required this.playerIndex,
      required this.roomID})
      : super(
          const MojBrojInitial(),
        ) {
    on<MojBrojSyncEvent>(_syncData);
    on<MojBrojStartNumberShuffle>(_startNumberShuffle);
    on<MojBrojChooseNumbersEvent>(_chooseNumbers);
    on<MojBrojCalculateEvent>(_calculations);
    on<MojBrojAddCalculationEvent>(_addCalculation);
    on<MojBrojRemoveCalculationEvent>(_removeCalculation);
    on<MojBrojSubmitExpressionEvent>(_submitCalculation);
    on<MojBrojEndGameEvent>(_endGame);
    on<MojBrojRestartGameEvent>(_restartGame);

    add(const MojBrojSyncEvent());
  }

  _default() {
    localExpression = "";
    localSmallNumbers = [0, 0, 0, 0];
    localMiddleNumber = 0;
    localBigNumber = 0;
    localGoal = 0;
    lastState = "";
    result = "";
    clickedNumbers = [];
    generateNumbersTimer = null;
    winner = 0;
  }

  _restartGame(MojBrojRestartGameEvent event, Emitter<MojBrojState> emit) {
    if (mojBroj.turn == 2 || opponentPlayer.ready == false) {
      print("Switch game");
      return;
    } else if (opponentPlayer.ready) {
      FirebaseFirestore.instance.collection('rooms').doc(roomID).update({
        "mojBroj.playerOneExpression": "",
        "mojBroj.playerOneExpressionResult": "",
        "mojBroj.playerTwoExpression": "",
        "mojBroj.playerTwoExpressionResult": "",
        "mojBroj.turn": mojBroj.turn == 1 ? 2 : 1,
        "mojBroj.event": "initMojBroj",
        "mojBroj.smallNumbers": [],
        "turn": mojBroj.turn == 1 ? 2 : 1,
      });
    }
  }

  updatePlayerPressence(
      GameRoomModel room, PlayerModel player1, PlayerModel player2) {
    if (playerIndex == 1) {
      controlledPlayer = player1;
      opponentPlayer = player2;
    } else {
      controlledPlayer = player2;
      opponentPlayer = player1;
    }

    if (opponentPlayer.ready == false) {
      if (mojBroj.turn == playerIndex) {
        FirebaseFirestore.instance.collection('rooms').doc(roomID).update({
          "mojBroj.player${playerIndex == 1 ? "Two" : "One"}Expression":
              "Greška",
          "mojBroj.player${playerIndex == 1 ? "Two" : "One"}ExpressionResult":
              "Greška",
        });
      } else if (mojBroj.turn == 2) {
        //TODO: Switch game
        print("Switch game");
      } else {
        add(const MojBrojRestartGameEvent());
      }
    }
  }

  updateState(MojBrojModel state, PlayerModel player1, PlayerModel player2) {
    if (state.turn != mojBroj.turn) {
      _default();
    }
    mojBroj = state;

    if (playerIndex == 1) {
      controlledPlayer = player1;
      opponentPlayer = player2;
    } else {
      controlledPlayer = player2;
      opponentPlayer = player1;
    }

    add(const MojBrojSyncEvent());
  }

  _syncData(MojBrojSyncEvent event, Emitter<MojBrojState> emit) {
    String controlledPlayerExpression = "";
    String opponentPlayerExpression = "";

    if (playerIndex == 1) {
      controlledPlayerExpression = mojBroj.playerOneExpression;
      opponentPlayerExpression = mojBroj.playerTwoExpression;
    } else {
      controlledPlayerExpression = mojBroj.playerTwoExpression;
      opponentPlayerExpression = mojBroj.playerOneExpression;
    }

    emit(
      MojBrojInitedState(
          mojBroj: mojBroj,
          controlledPlayerExpression: controlledPlayerExpression,
          opponentPlayerExpression: opponentPlayerExpression,
          playerIndex: playerIndex,
          localSmallNumbers: localSmallNumbers,
          localMiddleNumber: localMiddleNumber,
          localBigNumber: localBigNumber,
          localGoal: localGoal,
          localExpression: localExpression,
          clickedNumbers: clickedNumbers,
          result: result,
          winner: winner),
    );
  }

  _startNumberShuffle(
      MojBrojStartNumberShuffle event, Emitter<MojBrojState> emit) {
    if (lastState == "startNumberShuffle") return;
    lastState = "startNumberShuffle";

    generateNumbersTimer =
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
      localSmallNumbers = [
        Random().nextInt(9) + 1,
        Random().nextInt(9) + 1,
        Random().nextInt(9) + 1,
        Random().nextInt(9) + 1,
      ];

      localMiddleNumber = possibleMiddleNumbers[Random().nextInt(4)];
      localBigNumber = possibleBigNumbers[Random().nextInt(3)];
      localGoal = Random().nextInt(998) + 1;

      add(const MojBrojSyncEvent());
    });

    playGameBloc.add(SetTimerEvent(GameTimer(
      "selectNumbers",
      6,
      () {
        if (mojBroj.turn == playerIndex) {
          add(const MojBrojChooseNumbersEvent());
        }
      },
    )));
  }

  _chooseNumbers(
      MojBrojChooseNumbersEvent event, Emitter<MojBrojState> emit) async {
    generateNumbersTimer?.cancel();
    await Future.delayed(const Duration(milliseconds: 500));
    if (lastState == "chooseNumbers") return;
    lastState = "chooseNumbers";

    if (playerIndex == mojBroj.turn) {
      FirebaseFirestore.instance.collection('rooms').doc(roomID).update({
        "mojBroj.smallNumbers": localSmallNumbers,
        "mojBroj.middleNumber": localMiddleNumber,
        "mojBroj.bigNumber": localBigNumber,
        "mojBroj.goal": localGoal,
      });
    }
  }

  _calculations(MojBrojCalculateEvent event, Emitter<MojBrojState> emit) {
    if (lastState == "calculations") return;
    lastState = "calculations";

    generateNumbersTimer?.cancel();
    generateNumbersTimer = null;

    playGameBloc.add(SetTimerEvent(GameTimer(
      "calculations",
      75,
      () {
        if (mojBroj.turn == playerIndex) {
          add(const MojBrojSubmitExpressionEvent());
        }
      },
    )));
  }

  _addCalculation(
      MojBrojAddCalculationEvent event, Emitter<MojBrojState> emit) {
    RefactorExpressionModel refactor =
        _refactorExpressionUseCase.call(RefactorExpressionModel(
      expression: localExpression,
      tapped: clickedNumbers,
      param: event.expression,
      index: event.index,
    ));

    localExpression = refactor.expression;
    clickedNumbers = refactor.tapped;

    add(const MojBrojSyncEvent());
  }

  _removeCalculation(
      MojBrojRemoveCalculationEvent event, Emitter<MojBrojState> emit) {
    if (localExpression.isEmpty) return;
    localExpression = _reduceExpressionUsecase.call(localExpression);
    if (clickedNumbers.isNotEmpty) {
      clickedNumbers.removeLast();
    }

    add(const MojBrojSyncEvent());
  }

  _submitCalculation(
      MojBrojSubmitExpressionEvent event, Emitter<MojBrojState> emit) {
    if (opponentPlayer.ready == false) {
      FirebaseFirestore.instance.collection('rooms').doc(roomID).update({
        "mojBroj.player${playerIndex == 1 ? "Two" : "One"}Expression": "Greška",
        "mojBroj.player${playerIndex == 1 ? "Two" : "One"}ExpressionResult":
            "Greška",
      });
    }

    if (localExpression.isEmpty) {
      try {
        result = "Greška";
        if (playerIndex == 1) {
          FirebaseFirestore.instance.collection('rooms').doc(roomID).update({
            "mojBroj.playerOneExpression": "Greška",
            "mojBroj.playerOneExpressionResult": result,
          });
          return;
        } else {
          FirebaseFirestore.instance.collection('rooms').doc(roomID).update({
            "mojBroj.playerTwoExpression": "Greška",
            "mojBroj.playerTwoExpressionResult": result,
          });
          return;
        }
      } catch (e) {
        print(e);
        result = "Greška";
      }
    }

    try {
      Expression expression = Expression.parse(localExpression);
      const evaluator = ExpressionEvaluator();
      var eval = evaluator.eval(expression, {});

      if (eval is int) {
        result = eval.toString();
      } else if (eval is double && eval == eval.toInt()) {
        result = eval.toInt().toString();
      } else {
        result = "Greska";
      }
    } catch (e) {
      print("Error evaluating expression: $e");
      result = "Greška";
    }

    try {
      if (playerIndex == 1) {
        FirebaseFirestore.instance.collection('rooms').doc(roomID).update({
          "mojBroj.playerOneExpression": localExpression,
          "mojBroj.playerOneExpressionResult": result,
        });
        return;
      } else {
        FirebaseFirestore.instance.collection('rooms').doc(roomID).update({
          "mojBroj.playerTwoExpression": localExpression,
          "mojBroj.playerTwoExpressionResult": result,
        });
        return;
      }
    } catch (e) {
      print(e);
      result = "Greška";
    }
  }

  _endGame(MojBrojEndGameEvent event, Emitter<MojBrojState> emit) {
    if (lastState == "endGame") return;
    lastState = "endGame";
    winner = 0;

    int? p1Difference;
    int? p2Difference;

    if (mojBroj.playerOneExpressionResult != "Greška" &&
        mojBroj.playerTwoExpressionResult != "Greška") {
      p1Difference =
          (mojBroj.goal - int.parse(mojBroj.playerOneExpressionResult)).abs();

      p2Difference =
          (mojBroj.goal - int.parse(mojBroj.playerTwoExpressionResult)).abs();

      if (p1Difference < p2Difference) {
        winner = 1;
      } else if (p1Difference > p2Difference) {
        winner = 2;
      } else {
        if (mojBroj.turn == 1) {
          winner = 1;
        } else {
          winner = 2;
        }
      }
    } else if (mojBroj.playerOneExpressionResult != "Greška") {
      winner = 1;
    } else if (mojBroj.playerTwoExpressionResult != "Greška") {
      winner = 2;
    }

    if (mojBroj.turn == playerIndex) {
      if (winner == 1) {
        FirebaseFirestore.instance.collection('rooms').doc(roomID).update({
          "player1.points": FieldValue.increment(20),
        });
      } else if (winner == 2) {
        FirebaseFirestore.instance.collection('rooms').doc(roomID).update({
          "player2.points": FieldValue.increment(20),
        });
      }
    }

    add(const MojBrojSyncEvent());

    playGameBloc.add(SetTimerEvent(GameTimer(
      "endGame",
      5,
      () {
        if (mojBroj.turn == playerIndex) {
          add(const MojBrojRestartGameEvent());
        }
      },
    )));
  }

  getExpressionString(String expression, String result) {
    if (expression == "Greška" || result == "Greška") {
      return "Greška";
    }

    return "$expression = $result";
  }
}
