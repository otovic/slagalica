import 'package:slagalica/features/app_state_init/data/models/game_room_model.dart';
import 'package:slagalica/features/game_room/domain/entities/game_room_credentials.dart';

class GameRoomCredentials extends GameRoomCredentialsEntity {
  GameRoomCredentials({required GameRoomModel room, required String username})
      : super(room: room, username: username);
}
