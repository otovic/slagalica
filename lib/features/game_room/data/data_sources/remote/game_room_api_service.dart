import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slagalica/features/app_state_init/data/models/game_room_model.dart';
import 'package:slagalica/features/app_state_init/data/models/player_model.dart';

class GameRoomApiService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> leaveRoom(GameRoomModel room, String username) async {
    if (room.player2 != null && room.player2!.name != "") {
      if (room.player2!.name == username) {
        room.player2 = PlayerModel.empty();
        _syncRoom(room);
      } else {
        _destroyRoom(room.id);
      }
    } else {
      _destroyRoom(room.id);
    }
  }

  Future<void> _syncRoom(GameRoomModel room) async {
    await _firestore.collection('rooms').doc(room.id).set(room.toJson());
  }

  Future<void> _destroyRoom(String roomID) async {
    print("DESTROYING ROOM: $roomID");
    await _firestore.collection('rooms').doc(roomID).delete();
  }
}
