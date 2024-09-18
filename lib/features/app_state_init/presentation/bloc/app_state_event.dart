import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:slagalica/core/resources/user_data_model.dart';

abstract class AppStateEvent {
  const AppStateEvent();
}

class AppStateInitEvent extends AppStateEvent {
  final BuildContext context;
  const AppStateInitEvent(this.context);
}

class ShowSnackBarEvent extends AppStateEvent {
  final BuildContext context;
  final String message;
  Duration duration;
  ShowSnackBarEvent(
      {required this.context,
      required this.message,
      this.duration = const Duration(seconds: 3)});
}

class AppStateUserChangedEvent extends AppStateEvent {
  final User? user;
  final UserDataModel? userData;
  const AppStateUserChangedEvent({
    required this.user,
    required this.userData,
  });
}

class AppStateCreateRoom extends AppStateEvent {
  const AppStateCreateRoom();
}

class AppStateDeleteRoom extends AppStateEvent {
  final BuildContext context;

  const AppStateDeleteRoom(this.context);
}

class AppStateDestroyRoom extends AppStateEvent {
  final Function onRoomDestroyed;
  const AppStateDestroyRoom(this.onRoomDestroyed);
}

class AppStateJoinRoomInit extends AppStateEvent {
  final String roomId;
  final Function callback;
  const AppStateJoinRoomInit({
    required this.roomId,
    required this.callback,
  });
}

class AppStateAppWentBackground extends AppStateEvent {
  const AppStateAppWentBackground();
}

class AppStateJoinRoom extends AppStateEvent {
  final String roomId;
  const AppStateJoinRoom({
    required this.roomId,
  });
}

class AppStateAppResumed extends AppStateEvent {
  const AppStateAppResumed();
}

class PurchaseSuccessfullEvent extends AppStateEvent {
  final BuildContext context;
  const PurchaseSuccessfullEvent(this.context);
}

class PurchaseFailedEvent extends AppStateEvent {
  final BuildContext context;
  const PurchaseFailedEvent(this.context);
}
