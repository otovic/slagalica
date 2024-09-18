import 'package:slagalica/core/services/game_service/game_entity.dart';
import 'package:slagalica/features/app_state_init/data/models/game_models/moj_broj_model.dart';
import 'package:slagalica/features/app_state_init/data/models/game_models/skocko_model.dart';
import 'package:slagalica/features/app_state_init/data/models/game_room_model.dart';
import 'package:slagalica/features/app_state_init/data/models/player_model.dart';
import 'package:slagalica/features/moj_broj/presentation/bloc/moj_broj_bloc.dart';
import 'package:slagalica/features/moj_broj/presentation/pages/moj_broj_render.dart';
import 'package:slagalica/features/play_game/presentation/bloc/play_game_bloc.dart';
import 'package:slagalica/features/skocko/presentation/bloc/skocko_bloc.dart';
import 'package:slagalica/features/skocko/presentation/pages/skocko_render.dart';

class Skocko extends GameEntity<GameRoomModel> {
  late SkockoBloc bloc;
  PlayGameBloc playGameBloc;

  SkockoModel? previousState;
  PlayerModel? previousPlayer1;
  PlayerModel? previousPlayer2;

  int playerIndex;
  final String gameRoomId;

  Skocko(
      this.playGameBloc, GameRoomModel room, this.playerIndex, this.gameRoomId)
      : super() {
    bloc = SkockoBloc(
        skocko: room.skocko,
        playGameBloc: playGameBloc,
        playerIndex: playerIndex,
        roomID: gameRoomId);

    setData(render: SkockoRender(bloc: bloc), data: room);
  }

  @override
  void updateState(GameRoomModel state) {
    SkockoModel nState = state.skocko;

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
        bloc.updatePlayerPressence(nState, state.player1!, state.player2!);
      } else if (state.player2!.compare(previousPlayer2!) == false &&
          playerIndex != 2) {
        bloc.updatePlayerPressence(nState, state.player1!, state.player2!);
      }
    } else {
      bloc.updateState(nState, state.player1!, state.player2!);
      previousState = nState;
      previousPlayer1 = state.player1;
      previousPlayer2 = state.player2;
    }
  }
}
