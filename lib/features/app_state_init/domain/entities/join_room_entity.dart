import 'package:slagalica/features/app_state_init/data/models/player_model.dart';

class JoinRoomEntity {
  final String roomId;
  final PlayerModel player;

  JoinRoomEntity({
    required this.roomId,
    required this.player,
  });
}
