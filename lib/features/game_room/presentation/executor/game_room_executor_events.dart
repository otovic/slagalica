import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:slagalica/core/services/event_driven_executor/event_driven_executor.dart';
import 'package:slagalica/features/app_state_init/data/models/game_room_model.dart';
import 'package:slagalica/features/play_game/presentation/pages/play_game_page.dart';

class InitGameEvent extends ExecutorEvent<GameRoomModel> {
  final String username;
  late final BuildContext context;
  InitGameEvent(this.username)
      : super(
          name: "InitGame",
          callback: (GameRoomModel state) async {
            if (state.player1!.name == username &&
                state.player1!.ready == false) {
              FirebaseFirestore.instance
                  .collection('rooms')
                  .doc(state.id)
                  .update({"player1.ready": true});
            } else if (state.player2!.name == username &&
                state.player2!.ready == false) {
              print("Player 2 ready");
              FirebaseFirestore.instance
                  .collection('rooms')
                  .doc(state.id)
                  .update({"player2.ready": true});
            }
            if (state.player1!.name == username) {
              if (state.player1!.ready && state.player2!.ready) {
                final room = state.copyWith(event: "StartGame");
                FirebaseFirestore.instance
                    .collection('rooms')
                    .doc(state.id)
                    .update({"event": "StartGame"});
              }
            }
          },
        );

  @override
  String getEventName(GameRoomModel state) {
    return state.event;
  }
}

class StartGameExecutorEvent extends ExecutorEvent<GameRoomModel> {
  late final BuildContext context;
  final String username;
  bool once = false;

  StartGameExecutorEvent(this.context, this.username)
      : super(
          name: "StartGame",
          callback: (GameRoomModel state) {
            print("Travvelin to play game");
            print(state.skocko.correct);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => PlayGamePage(
                    gameRoom: state,
                    username: username,
                  ),
                ),
                (route) => false);
          },
        );

  @override
  String getEventName(GameRoomModel state) {
    return state.event;
  }
}
