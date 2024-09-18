import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slagalica/core/exceptions/game_room_exceptions.dart';
import 'package:slagalica/features/app_state_init/data/models/game_models/moj_broj_model.dart';
import 'package:slagalica/features/app_state_init/data/models/game_models/skocko_model.dart';
import 'package:slagalica/features/app_state_init/data/models/game_models/slagalica_model.dart';
import 'package:slagalica/features/app_state_init/data/models/game_room_model.dart';
import 'package:slagalica/features/app_state_init/data/models/join_room_model.dart';
import 'package:slagalica/features/app_state_init/data/models/player_model.dart';

class GameRoomStateApiService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<GameRoomModel> createRoom(final PlayerModel player1) async {
    final String roomID = await _generateRoomID();
    final room = GameRoomModel(
      id: roomID,
      player1: player1,
      slagalica: SlagalicaModel.empty(),
      mojBroj: MojBrojModel.empty(),
      skocko: SkockoModel.empty(),
    );
    await _firestore.collection('rooms').doc(roomID).set(room.toJson());
    return room;
  }

  deleteRoom(final String roomID) async {
    _firestore.collection('rooms').doc(roomID).delete();
  }

  Future<GameRoomModel> joinRoom(final JoinRoomModel data) async {
    data.roomId = data.roomId.toUpperCase();
    final snapshot =
        await _firestore.collection('rooms').doc(data.roomId).get();
    if (!snapshot.exists) {
      throw GameRoomJoinException("Soba sa kodom ${data.roomId} ne postoji");
    }

    final room = GameRoomModel.fromJson(snapshot.data()!);
    if (room.player2 != null && room.player2!.name != "") {
      throw GameRoomJoinRoomFullException(
          "Soba sa kodom ${data.roomId} je puna");
    }
    room.player2 = data.player;
    await _firestore.collection('rooms').doc(data.roomId).set(room.toJson());
    return room;
  }

  Future<String> _generateRoomID() async {
    const String characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    final String roomID = List.generate(7,
            (index) => characters[DateTime.now().microsecondsSinceEpoch % 36])
        .join();

    final snapshot = await _firestore.collection('rooms').doc(roomID).get();
    while (snapshot.exists) {
      await Future.delayed(const Duration(seconds: 1));
      return await _generateRoomID();
    }

    return roomID;
  }
}
