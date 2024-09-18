import 'package:slagalica/features/app_state_init/data/models/game_room_model.dart';
import 'package:slagalica/features/app_state_init/data/models/join_room_model.dart';
import 'package:slagalica/features/app_state_init/data/models/player_model.dart';
import 'package:slagalica/features/app_state_init/domain/entities/game_room_entity.dart';
import 'package:slagalica/features/app_state_init/domain/entities/player_entity.dart';

abstract class GameRoomStateRepository {
  Future<GameRoomEntity> createRoom(final PlayerEntity player1);
  deleteRoom(final String roomID);
  Future<GameRoomModel> joinRoom(final JoinRoomModel data);
}
