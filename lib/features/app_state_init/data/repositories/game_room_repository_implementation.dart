import 'package:slagalica/features/app_state_init/data/data_sources/remote/game_room_state_api_service.dart';
import 'package:slagalica/features/app_state_init/data/models/game_room_model.dart';
import 'package:slagalica/features/app_state_init/data/models/join_room_model.dart';
import 'package:slagalica/features/app_state_init/data/models/player_model.dart';
import 'package:slagalica/features/app_state_init/domain/entities/player_entity.dart';
import 'package:slagalica/features/app_state_init/domain/repository/game_room_state_repository.dart';

class GameRoomStateRepositoryImplementation extends GameRoomStateRepository {
  final GameRoomStateApiService _apiService;

  GameRoomStateRepositoryImplementation(this._apiService);

  @override
  Future<GameRoomModel> createRoom(final PlayerEntity player1) async {
    return _apiService.createRoom(PlayerModel.fromEntity(player1));
  }

  @override
  deleteRoom(final String roomID) {
    return _apiService.deleteRoom(roomID);
  }

  @override
  Future<GameRoomModel> joinRoom(final JoinRoomModel data) {
    return _apiService.joinRoom(data);
  }
}
