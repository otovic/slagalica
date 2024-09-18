import 'package:flutter/material.dart';
import 'package:slagalica/features/app_state_init/data/models/game_room_model.dart';

abstract class GameEntity<T> {
  late Widget render;
  late T state;
  int turn = 0;

  GameEntity();

  void setData({required Widget render, required T data}) {
    this.render = render;
    this.state = data;
  }

  void updateState(GameRoomModel newState) {}
  void notifyDisconnected() {}
}
