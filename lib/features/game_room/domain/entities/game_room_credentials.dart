import 'package:slagalica/features/app_state_init/data/models/game_room_model.dart';

class GameRoomCredentialsEntity {
  final GameRoomModel room;
  final String username;

  GameRoomCredentialsEntity({required this.room, required this.username});
}
