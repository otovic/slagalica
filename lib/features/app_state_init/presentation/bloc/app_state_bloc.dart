import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localstorage/localstorage.dart';
import 'package:slagalica/core/exceptions/game_room_exceptions.dart';
import 'package:slagalica/core/resources/user_data_model.dart';
import 'package:slagalica/core/services/firestore_service.dart';
import 'package:slagalica/features/app_state_init/data/models/app_state_model.dart';
import 'package:slagalica/features/app_state_init/data/models/game_room_model.dart';
import 'package:slagalica/features/app_state_init/data/models/join_room_model.dart';
import 'package:slagalica/features/app_state_init/data/models/player_model.dart';
import 'package:slagalica/features/app_state_init/domain/entities/player_entity.dart';
import 'package:slagalica/features/app_state_init/domain/usecases/create_room.dart';
import 'package:slagalica/features/app_state_init/domain/usecases/delete_room.dart';
import 'package:slagalica/features/app_state_init/domain/usecases/init_app_state.dart';
import 'package:slagalica/features/app_state_init/domain/usecases/join_room.dart';
import 'package:slagalica/features/app_state_init/presentation/bloc/app_state_event.dart';
import 'package:slagalica/features/app_state_init/presentation/bloc/app_state_state.dart';
import 'package:slagalica/shared/widgets/show_snack_error.dart';

class AppStateBloc extends Bloc<AppStateEvent, AppStateState>
    with WidgetsBindingObserver {
  final AppStateInitUseCase _initUseCase;
  final CreateRoomUseCase _createRoomUseCase;
  final DeleteRoomUseCase _deleteRoomUseCase;
  final JoinRoomUseCase _joinRoomUseCase;
  late StreamSubscription<User?> _authSubscription;
  late StreamSubscription<DocumentSnapshot>? _roomSubscription;
  GameRoomModel? _gameRoom = null;
  int r = Random().nextInt(100);

  AppStateBloc(
    this._initUseCase,
    this._createRoomUseCase,
    this._deleteRoomUseCase,
    this._joinRoomUseCase,
  ) : super(AppStateUninitialized()) {
    on<AppStateInitEvent>((event, emit) => _onAppStarted(event, emit));
    on<AppStateUserChangedEvent>((event, emit) => _onUserChanged(event, emit));
    on<ShowSnackBarEvent>(
      (event, emit) => _onShowSnackBar(event, emit),
    );
    on<AppStateCreateRoom>(
      (event, emit) => _createRoom(event, emit),
    );
    on<AppStateDeleteRoom>(
      (event, emit) => _deleteRoom(event, emit),
    );
    on<AppStateDestroyRoom>(_destroyRoom);
    on<AppStateJoinRoomInit>(_joinRoomInit);
    on<AppStateJoinRoom>(_joinRoom);
    on<AppStateAppWentBackground>(_appWentBackground);
    on<AppStateAppResumed>((event, emit) => _appResumed());
    on<PurchaseSuccessfullEvent>(
        (event, emit) => _purchaseSuccess(event, emit));
    on<PurchaseFailedEvent>((event, emit) => _purchaseFailed(event, emit));
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      add(const AppStateAppWentBackground());
    } else if (state == AppLifecycleState.resumed) {
      add(const AppStateAppResumed());
    } else if (state == AppLifecycleState) {
      add(const AppStateAppWentBackground());
    }
  }

  Future<void> _onAppStarted(
      AppStateInitEvent event, Emitter<AppStateState> emit) async {
    try {
      final data =
          AppStateModel.fromEntity(await _initUseCase.call(event.context));

      emit(AppStateInitializedData(data));

      _authSubscription =
          FirebaseAuth.instance.authStateChanges().listen((User? user) async {
        if (user == null) {
          add(const AppStateUserChangedEvent(user: null, userData: null));
        } else {
          UserDataModel? userData = await UserDataModel.fetchUserData(user.uid);
          int tries = 0;
          while (userData == null) {
            await Future.delayed(const Duration(seconds: 2));
            userData = await UserDataModel.fetchUserData(user.uid);
            tries++;
            if (tries > 5) {
              emit(AppStateError());
              return;
            }
          }
          add(AppStateUserChangedEvent(user: user, userData: userData));
        }
      });
    } catch (e) {
      emit(AppStateError());
    }
  }

  void _onUserChanged(
      AppStateUserChangedEvent event, Emitter<AppStateState> emit) {
    final appState = state.data;
    emit(
      AppStateInitializedUser(
        appState!.copyWith(user: event.user, userData: event.userData),
      ),
    );
  }

  Future<void> _onShowSnackBar(
      ShowSnackBarEvent event, Emitter<AppStateState> emit) async {
    try {
      if (state.data!.snackBarActive) return;
      final appState = state.data;

      _showSnackBar(event.context, event);
      emit(
        AppStateInitializedUser(appState!.copyWith(snackBarActive: true)),
      );

      await Future.delayed(const Duration(seconds: 3));

      emit(
        AppStateInitializedUser(
          appState.copyWith(snackBarActive: false),
        ),
      );
    } catch (e) {
      print("App State Block Error: " + e.toString());
    }
  }

  _showSnackBar(BuildContext context, ShowSnackBarEvent event,
      {bool error = true}) {
    showSnackError(event.context, event.message,
        duration: event.duration, isWarning: error);
  }

  List<String> getDeviceData() {
    if (state.data!.OS == 'android') {
      return [
        state.data!.androidDeviceInfo!.id,
        state.data!.androidDeviceInfo!.model,
      ];
    } else {
      return [
        state.data!.iOSDeviceInfo!.identifierForVendor!,
        state.data!.iOSDeviceInfo!.model,
      ];
    }
  }

  Future<void> _createRoom(
      AppStateCreateRoom event, Emitter<AppStateState> emit) async {
    if (state.data?.userData != null && state.data!.userData!.coins <= 0) {
      emit(AppStateCreateRoomError("Nemate dovoljno žetona", state.data!));
      return;
    }
    if (state is AppStateCreatingRoom) return Future.value();
    emit(AppStateCreatingRoom(state.data!));
    await Future.delayed(const Duration(seconds: 1));

    try {
      _gameRoom = await _createRoomUseCase.call(
        PlayerEntity(
          id: state.data!.user!.uid,
          name: state.data!.userData!.username,
          image: state.data!.userData!.imageURL ?? "",
          wins: state.data!.userData!.wins,
          rank: 0,
          points: 0,
        ),
      );

      emit(AppStateRoomCreated(_gameRoom!, state.data!));
    } catch (e) {
      print("Error creating room: " + e.toString());
      emit(AppStateCreateRoomError(
          "Greska prilikom kreiranja sobe", state.data!));
    }
  }

  _deleteRoom(AppStateDeleteRoom event, Emitter<AppStateState> emit) {
    try {
      if (_gameRoom == null) return;
      _gameRoom = null;
    } catch (e) {
      print("Error deleting room: " + e.toString());
    }
  }

  Future<void> _destroyRoom(
      AppStateDestroyRoom event, Emitter<AppStateState> emit) async {
    try {
      print("Ap State Bloc: Destroying room");
      event.onRoomDestroyed();
      _gameRoom = null;
      emit(AppStateInitializedUser(state.data!));
    } catch (e) {
      print("Error destroying room: " + e.toString());
      emit(AppStateInitializedUser(state.data!));
    }
  }

  Future<void> _joinRoomInit(
      AppStateJoinRoomInit event, Emitter<AppStateState> emit) async {
    if (state.data?.userData?.coins != null &&
        state.data!.userData!.coins <= 0) {
      emit(AppStateRoomJoinError("Nemate dovoljno žetona", state.data!));
      return;
    }
    event.callback();
    await Future.delayed(const Duration(seconds: 1));
    try {} on GameRoomJoinException catch (e) {
      print("Error joining room: " + e.message);
      emit(AppStateRoomJoinError(e.message, state.data!));
    } catch (e) {
      print("Error joining room: " + e.toString());
      emit(AppStateRoomJoinError("Došlo je do greške", state.data!));
    }
  }

  _joinRoom(AppStateJoinRoom event, Emitter<AppStateState> emit) async {
    if (state is AppStateJoiningRoom) return;
    emit(AppStateJoiningRoom(state.data!));
    if (event.roomId.isEmpty || event.roomId.length != 7) {
      emit(AppStateRoomJoinError("Unesite validan kod", state.data!));
      return;
    }
    await Future.delayed(const Duration(seconds: 1));
    try {
      _gameRoom = await _joinRoomUseCase.call(
        JoinRoomModel(
          roomId: event.roomId,
          player: PlayerModel(
            id: state.data!.user!.uid,
            name: state.data!.userData!.username,
            image: state.data!.userData!.imageURL ?? "",
            wins: state.data!.userData!.wins,
            rank: 0,
            points: 0,
          ),
        ),
      );
      emit(AppStateRoomJoined(_gameRoom!, state.data!));
    } on GameRoomJoinException catch (e) {
      print("Error joining room: " + e.toString());
      emit(AppStateRoomJoinError(e.message, state.data!));
    } catch (e) {
      print("Error joining room: " + e.toString());
      emit(AppStateRoomJoinError("Došlo je do greške", state.data!));
    }
  }

  _purchaseSuccess(
      PurchaseSuccessfullEvent event, Emitter<AppStateState> emit) {
    try {
      _showSnackBar(
          event.context,
          ShowSnackBarEvent(
            context: event.context,
            message: "Uspesno ste kupili žetone",
          ),
          error: false);
    } catch (e) {
      print("Error updating coins: " + e.toString());
    }
  }

  _purchaseFailed(PurchaseFailedEvent event, Emitter<AppStateState> emit) {
    try {
      _showSnackBar(
          event.context,
          ShowSnackBarEvent(
            context: event.context,
            message: "Greska prilikom kupovine",
          ));
    } catch (e) {
      print("Error updating coins: " + e.toString());
    }
  }

  _appWentBackground(
      AppStateAppWentBackground event, Emitter<AppStateState> emit) {
    if (_gameRoom == null) return;
    _gameRoom = null;
  }

  _appResumed() {
    print("App resumed");
    if (_gameRoom == null) return;
    _gameRoom = null;
  }

  getUserData() {
    return state.data!.userData;
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }
}
