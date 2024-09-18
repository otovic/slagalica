library play_game_bloc;

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slagalica/core/services/game_service/game_entity.dart';
import 'package:slagalica/core/utils/game_timer.dart';
import 'package:slagalica/features/app_state_init/data/models/game_room_model.dart';
import 'package:slagalica/features/moj_broj/presentation/moj_broj.dart';
import 'package:slagalica/features/skocko/presentation/skocko.dart';
import 'package:slagalica/features/slagalica/presentation/slagalica.dart';

part 'play_game_events.dart';
part 'play_game_state.dart';

class PlayGameBloc extends Bloc<PlayGameEvent, PlayGameState> {
  GameRoomModel gameRoom;
  StreamSubscription<DocumentSnapshot>? _subscription;
  final String username;
  int _oobIndex = 0;
  Timer? _timer = null;
  Timer? _oob = null;
  List<GameEntity> _games = [];
  GameTimer? _gameTimer;
  bool _isTimerRunning = false;

  bool enabled = true;

  PlayGameBloc(this.gameRoom, this.username)
      : super(const PlayGameLoadingState()) {
    on<FinishedLoadingEvent>(_initLoad);
    on<SyncDataEvent>(_syncData);
    on<SyncTimerEvent>(_syncTimer);
    on<SetTimerEvent>(_setTimer);
    on<InitTimerEvent>(_initTimer);

    _subscription = FirebaseFirestore.instance
        .collection('rooms')
        .doc(gameRoom.id)
        .snapshots()
        .listen((event) async {
      if (!event.exists) {
        await _subscription?.cancel();
        return;
      }
      gameRoom = GameRoomModel.fromJson(event.data()!);
      if (state is PlayGameLoadingState) {
        print("Finished loading");
        add(const FinishedLoadingEvent());
      } else {
        add(SyncDataEvent(gameRoom));
      }
    });

    _oob = Timer.periodic(const Duration(seconds: 15), (timer) async {
      if (enabled) return;
      if (state is PlayGameLoadedState) {
        var currentState = state as PlayGameLoadedState;
        if (currentState.gameRoom.player1!.name == username) {
          currentState.gameRoom.player1 = currentState.gameRoom.player1!
              .copyWith(event: _oobIndex.toString());
          _oobIndex++;
          FirebaseFirestore.instance
              .collection("rooms")
              .doc(gameRoom.id)
              .update({"player1.event": _oobIndex.toString()});
        } else {
          currentState.gameRoom.player2 = currentState.gameRoom.player2!
              .copyWith(event: _oobIndex.toString());
          _oobIndex++;
          FirebaseFirestore.instance
              .collection("rooms")
              .doc(gameRoom.id)
              .update({"player2.event": _oobIndex.toString()});
        }
      }
    });

    _timer = Timer.periodic(const Duration(seconds: 20), (timer) {
      if (enabled) return;
      if (_getPlayerIndex() == 1) {
        FirebaseFirestore.instance
            .collection("rooms")
            .doc(gameRoom.id)
            .update({"player2.ready": false});
        print("DISCONECTING PLAYER 2");
      } else {
        FirebaseFirestore.instance
            .collection("rooms")
            .doc(gameRoom.id)
            .update({"player1.ready": false});
        print("DISCONECTING PLAYER 1");
      }
    });
  }

  _initLoad(FinishedLoadingEvent event, Emitter<PlayGameState> emit) {
    print("Init loading");
    _games.add(
      Skocko(this, gameRoom, _getPlayerIndex(), gameRoom.id),
      // MojBroj(this, gameRoom, _getPlayerIndex(), gameRoom.id),
      // Slagalica(this, gameRoom.slagalica, _getPlayerIndex(), gameRoom.id),
    );
    emit(PlayGameLoadedState(gameRoom, _games.first));
  }

  _syncTimer(SyncTimerEvent event, Emitter<PlayGameState> emit) {
    var currentState = state as PlayGameLoadedState;
    emit(PlayGameLoadedState(currentState.gameRoom, currentState.currentGame,
        time: event.time, turn: event.turn));
  }

  _syncData(SyncDataEvent event, Emitter<PlayGameState> emit) {
    if (state is PlayGameLoadedState) {
      var currentState = state as PlayGameLoadedState;

      _games.first.updateState(event.gameRoom);

      emit(PlayGameLoadedState(event.gameRoom, currentState.currentGame,
          time: currentState.time, turn: event.gameRoom.turn));

      if (event.gameRoom.player1!.name == username) {
        if (event.gameRoom.player2!.event !=
            currentState.gameRoom.player2!.event) {
          print("Resetting timer player 2");
          _timer?.cancel();
          _timer = Timer.periodic(const Duration(seconds: 20), (timer) {
            if (enabled) return;
            _games.first.notifyDisconnected();
            FirebaseFirestore.instance
                .collection("rooms")
                .doc(gameRoom.id)
                .update({"player2.ready": false});
          });
        }
      } else if (event.gameRoom.player1!.event !=
          currentState.gameRoom.player1!.event) {
        print("Resetting timer player 1");
        _timer?.cancel();
        _timer = Timer.periodic(const Duration(seconds: 20), (timer) {
          if (enabled) return;
          _games.first.notifyDisconnected();
          FirebaseFirestore.instance
              .collection("rooms")
              .doc(gameRoom.id)
              .update({"player1.ready": false});
        });
      }
    }
  }

  _setTimer(SetTimerEvent event, Emitter<PlayGameState> emit) {
    if (event.gameTimer.id != _gameTimer?.id) {
      _gameTimer = event.gameTimer;
      if (!_isTimerRunning) {
        add(InitTimerEvent(_gameTimer!));
      }
    }
  }

  _initTimer(InitTimerEvent event, Emitter<PlayGameState> emit) async {
    _isTimerRunning = true;

    while (_gameTimer != null && _gameTimer!.seconds > -1) {
      var currentState = state as PlayGameLoadedState;
      emit(PlayGameLoadedState(gameRoom, _games.first,
          time: _gameTimer!.seconds, turn: currentState.turn));
      _gameTimer!.seconds--;
      await Future.delayed(const Duration(seconds: 1));
    }

    _gameTimer!.callback();
    _isTimerRunning = false;
  }

  _getPlayerIndex() {
    if (gameRoom.player1!.name == username) {
      return 1;
    } else {
      return 2;
    }
  }

  @override
  Future<void> close() async {
    _subscription?.cancel();
    _timer?.cancel();
    _oob?.cancel();
    return super.close();
  }
}
