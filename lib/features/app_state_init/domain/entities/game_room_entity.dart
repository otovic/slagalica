import 'package:slagalica/features/app_state_init/data/models/game_models/moj_broj_model.dart';
import 'package:slagalica/features/app_state_init/data/models/game_models/skocko_model.dart';
import 'package:slagalica/features/app_state_init/data/models/game_models/slagalica_model.dart';
import 'package:slagalica/features/app_state_init/data/models/player_model.dart';
import 'package:slagalica/features/app_state_init/domain/entities/game_entities/slagalica_entity.dart';

class GameRoomEntity {
  late final String id;
  String event = "";
  PlayerModel? player1;
  PlayerModel? player2;
  int turn = 1;
  SlagalicaModel slagalica;
  MojBrojModel mojBroj;
  SkockoModel skocko;

  GameRoomEntity({
    required this.id,
    this.event = "",
    required this.player1,
    this.player2,
    this.turn = 1,
    required this.slagalica,
    required this.mojBroj,
    required this.skocko,
  });
}
