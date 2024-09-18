import 'package:slagalica/features/app_state_init/data/models/game_room_model.dart';
import 'package:slagalica/features/app_state_init/domain/entities/game_room_entity.dart';

abstract class GameRoomRepository {
  Future<void> leaveRoom(GameRoomModel room, String username);
}
