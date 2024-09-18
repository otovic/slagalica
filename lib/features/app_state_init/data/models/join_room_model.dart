import 'package:slagalica/features/app_state_init/data/models/player_model.dart';
import 'package:slagalica/features/app_state_init/domain/entities/join_room_entity.dart';

class JoinRoomModel extends JoinRoomEntity {
  String roomId;
  final PlayerModel player;

  JoinRoomModel({
    required this.roomId,
    required this.player,
  }) : super(roomId: roomId, player: player);
}
