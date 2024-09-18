import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slagalica/core/services/event_driven_executor/event_driven_executor.dart';
import 'package:slagalica/features/app_state_init/data/models/game_room_model.dart';
import 'package:slagalica/features/app_state_init/presentation/bloc/app_state_bloc.dart';
import 'package:slagalica/features/app_state_init/presentation/bloc/app_state_event.dart';
import 'package:slagalica/features/game_room/data/models/game_room_credentials.dart';
import 'package:slagalica/features/game_room/domain/usecases/leave_room_use_case.dart';
import 'package:slagalica/features/game_room/presentation/bloc/game_room_event.dart';
import 'package:slagalica/features/game_room/presentation/bloc/game_room_state.dart';
import 'package:slagalica/features/game_room/presentation/executor/game_room_executor_events.dart';

class GameRoomBloc extends Bloc<GameRoomEvent, GameRoomState>
    with EventDrivenExecutor<GameRoomModel> {
  GameRoomModel? initialState;
  final AppStateBloc appStateBloc;
  final String username;
  late BuildContext context;
  LeaveRoomUseCase leaveRoomUseCase;
  StreamSubscription<DocumentSnapshot>? _subscription;
  GameRoomBloc(this.appStateBloc, this.username, this.leaveRoomUseCase,
      BuildContext context)
      : super(GameRoomUninitialized()) {
    on<GameRoomInitialize>(_gameRoomInit);
    on<GameRoomDestroyedEvent>(_gameRoomDestroy);
    on<SyncGameRoom>(_syncGameRoom);
    on<LeaveGameRoom>(_leaveRoom);
    on<InitStartGameEvent>(_initStartGame);
    addExecutorEvent(InitGameEvent(username));
    addExecutorEvent(StartGameExecutorEvent(context, username));
  }

  Future<void> _gameRoomInit(
      GameRoomInitialize event, Emitter<GameRoomState> emit) async {
    _subscription = FirebaseFirestore.instance
        .collection('rooms')
        .doc(event.room.id)
        .snapshots()
        .listen((event) async {
      if (!event.exists) {
        await _subscription?.cancel();
        add(const GameRoomDestroyedEvent());
        return;
      }
      final room = GameRoomModel.fromJson(event.data()!);
      if (room.event == "StartGame") {
        _subscription?.cancel();
      }
      initialState = room;
      fireEvent(room);
      add(SyncGameRoom(room));
    });
  }

  Future<void> _gameRoomDestroy(
      GameRoomDestroyedEvent event, Emitter<GameRoomState> emit) async {
    emit(GameRoomDestroyed());
  }

  Future<void> _syncGameRoom(
      SyncGameRoom event, Emitter<GameRoomState> emit) async {
    emit(GameRoomInitialized(event.room));
  }

  Future<void> _leaveRoom(
      LeaveGameRoom event, Emitter<GameRoomState> emit) async {
    try {
      this.appStateBloc.add(AppStateDestroyRoom(() async {
        await leaveRoomUseCase(
            GameRoomCredentials(room: state.data!, username: username));
      }));
    } catch (e) {
      print(e);
    }
  }

  Future<void> _initStartGame(
      InitStartGameEvent event, Emitter<GameRoomState> emit) async {
    try {
      var batch = FirebaseFirestore.instance.batch();
      batch.update(
          FirebaseFirestore.instance.collection('rooms').doc(state.data!.id),
          state.data!.copyWith(event: "InitGame").toJson());

      batch.update(
          FirebaseFirestore.instance
              .collection("users")
              .doc(initialState!.player1!.id),
          {"coins": FieldValue.increment(-1)});

      batch.update(
          FirebaseFirestore.instance
              .collection("users")
              .doc(initialState!.player2!.id),
          {"coins": FieldValue.increment(-1)});

      await batch.commit();
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> close() async {
    _subscription?.cancel();
    if (state.data!.event != "StartGame") {
      appStateBloc.add(AppStateDestroyRoom(() async {
        await leaveRoomUseCase(
            GameRoomCredentials(room: state.data!, username: username));
      }));
    }
    return super.close();
  }
}
