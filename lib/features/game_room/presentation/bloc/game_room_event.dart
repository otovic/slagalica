import 'package:flutter/material.dart';
import 'package:slagalica/features/app_state_init/data/models/game_room_model.dart';

abstract class GameRoomEvent {
  const GameRoomEvent();
}

class GameRoomInitialize extends GameRoomEvent {
  final GameRoomModel room;
  const GameRoomInitialize(this.room);
}

class GameRoomDestroyedEvent extends GameRoomEvent {
  const GameRoomDestroyedEvent();
}

class GameRoomDismissing extends GameRoomEvent {
  final BuildContext context;
  const GameRoomDismissing(this.context);
}

class SyncGameRoom extends GameRoomEvent {
  final GameRoomModel room;
  const SyncGameRoom(this.room);
}

class LeaveGameRoom extends GameRoomEvent {
  final String username;
  const LeaveGameRoom(this.username);
}

class InitStartGameEvent extends GameRoomEvent {
  const InitStartGameEvent();
}
