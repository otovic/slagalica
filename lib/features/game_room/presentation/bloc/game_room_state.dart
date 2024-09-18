import 'package:slagalica/features/app_state_init/data/models/game_models/moj_broj_model.dart';
import 'package:slagalica/features/app_state_init/data/models/game_models/skocko_model.dart';
import 'package:slagalica/features/app_state_init/data/models/game_models/slagalica_model.dart';
import 'package:slagalica/features/app_state_init/data/models/game_room_model.dart';

abstract class GameRoomState {
  final GameRoomModel? data;

  GameRoomState({required this.data});
}

class GameRoomUninitialized extends GameRoomState {
  GameRoomUninitialized()
      : super(
          data: GameRoomModel(
            id: 'uninitialized',
            player1: null,
            player2: null,
            slagalica: SlagalicaModel.empty(),
            mojBroj: MojBrojModel.empty(),
            skocko: SkockoModel.empty(),
          ),
        );
}

class GameRoomDismissed extends GameRoomState {
  GameRoomDismissed()
      : super(
          data: GameRoomModel(
            id: 'dismissed',
            player1: null,
            player2: null,
            slagalica: SlagalicaModel.empty(),
            mojBroj: MojBrojModel.empty(),
            skocko: SkockoModel.empty(),
          ),
        );
}

class GameRoomInitialized extends GameRoomState {
  GameRoomInitialized(GameRoomModel data) : super(data: data);
}

class GameRoomDestroyed extends GameRoomState {
  GameRoomDestroyed()
      : super(
          data: GameRoomModel(
            id: 'destroyed',
            player1: null,
            player2: null,
            slagalica: SlagalicaModel.empty(),
            mojBroj: MojBrojModel.empty(),
            skocko: SkockoModel.empty(),
          ),
        );
}

class GameRoomStarted extends GameRoomState {
  GameRoomStarted(GameRoomModel data) : super(data: data);
}
