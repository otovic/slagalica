import 'package:flutter/material.dart';
import 'package:slagalica/core/services/game_service/game_entity.dart';
import 'package:slagalica/features/app_state_init/data/models/game_models/slagalica_model.dart';
import 'package:slagalica/features/app_state_init/data/models/game_room_model.dart';
import 'package:slagalica/features/app_state_init/data/models/player_model.dart';
import 'package:slagalica/features/play_game/presentation/bloc/play_game_bloc.dart';
import 'package:slagalica/features/slagalica/presentation/bloc/slagalica_bloc.dart';
import 'package:slagalica/features/slagalica/presentation/pages/slagalica_render.dart';

class Slagalica extends GameEntity<SlagalicaModel> {
  late SlagalicaBloc bloc;
  PlayGameBloc playGameBloc;
  SlagalicaModel? previousState;
  PlayerModel? previousPlayer1;
  PlayerModel? previousPlayer2;
  int playerIndex;
  final String gameRoomId;
  Slagalica(this.playGameBloc, SlagalicaModel slagalica, this.playerIndex,
      this.gameRoomId)
      : super() {
    bloc = SlagalicaBloc(slagalica, playerIndex, playGameBloc, gameRoomId);
    setData(render: SlagalicaRender(bloc: bloc), data: slagalica);
  }

  @override
  void updateState(GameRoomModel state) {
    SlagalicaModel nState = state.slagalica;

    if (previousState != null &&
        previousPlayer1 != null &&
        previousPlayer2 != null) {
      if (nState.compare(previousState!) == false) {
        bloc.updateState(nState, state.player1!, state.player2!);
        previousState = nState;
        previousPlayer1 = state.player1;
        previousPlayer2 = state.player2;
      } else if (state.player1!.compare(previousPlayer1!) == false &&
          playerIndex != 1) {
        bloc.updatePlayerPressence(state, state.player1!, state.player2!);
      } else if (state.player2!.compare(previousPlayer2!) == false &&
          playerIndex != 2) {
        bloc.updatePlayerPressence(state, state.player1!, state.player2!);
      }
    } else {
      print("NIS");
      bloc.updateState(nState, state.player1!, state.player2!);
      previousState = nState;
      previousPlayer1 = state.player1;
      previousPlayer2 = state.player2;
    }
  }

  @override
  void notifyDisconnected() {
    // bloc.add(const SlagalicaPlayerDisconnectedEvent());
  }
}
