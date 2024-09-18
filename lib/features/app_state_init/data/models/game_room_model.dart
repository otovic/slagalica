import 'package:slagalica/features/app_state_init/data/models/game_models/moj_broj_model.dart';
import 'package:slagalica/features/app_state_init/data/models/game_models/skocko_model.dart';
import 'package:slagalica/features/app_state_init/data/models/game_models/slagalica_model.dart';
import 'package:slagalica/features/app_state_init/data/models/player_model.dart';
import 'package:slagalica/features/app_state_init/domain/entities/game_room_entity.dart';

class GameRoomModel extends GameRoomEntity {
  late final String id;
  String event = "";
  PlayerModel? player1;
  PlayerModel? player2;
  int turn = 1;
  SlagalicaModel slagalica;
  MojBrojModel mojBroj;
  SkockoModel skocko;

  GameRoomModel({
    required this.id,
    this.event = "",
    required this.player1,
    this.player2,
    this.turn = 1,
    required this.slagalica,
    required this.mojBroj,
    required this.skocko,
  }) : super(
          id: id,
          player1: player1,
          player2: player2,
          slagalica: slagalica,
          mojBroj: mojBroj,
          skocko: skocko,
        );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event': event,
      'player1': player1!.toJson(),
      'player2':
          player2 != null ? player2!.toJson() : PlayerModel.empty().toJson(),
      'turn': turn,
      'slagalica': slagalica.toJson(),
      'mojBroj': mojBroj.toJson(),
      'skocko': skocko.toJson(),
    };
  }

  factory GameRoomModel.fromJson(Map<String, dynamic> json) {
    return GameRoomModel(
      id: json['id'],
      event: json['event'],
      player1: PlayerModel.fromJson(json['player1']),
      player2: PlayerModel.fromJson(json['player2']),
      turn: json['turn'],
      slagalica: SlagalicaModel.fromJson(json['slagalica']),
      mojBroj: MojBrojModel.fromJson(json['mojBroj']),
      skocko: SkockoModel.fromJson(json['skocko']),
    );
  }

  GameRoomModel copyWith({
    String? id,
    String? event,
    PlayerModel? player1,
    PlayerModel? player2,
    int? turn,
    SlagalicaModel? slagalica,
    MojBrojModel? mojBroj,
    SkockoModel? skocko,
  }) {
    return GameRoomModel(
      id: id ?? this.id,
      event: event ?? this.event,
      player1: player1 ?? this.player1,
      player2: player2 ?? this.player2,
      turn: turn ?? this.turn,
      slagalica: slagalica ?? this.slagalica,
      mojBroj: mojBroj ?? this.mojBroj,
      skocko: skocko ?? this.skocko,
    );
  }

  @override
  String toString() {
    return 'GameRoomModel{id: $id, event: $event, player1: $player1, player2: $player2}';
  }
}
