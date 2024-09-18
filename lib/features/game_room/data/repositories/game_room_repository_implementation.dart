import 'package:slagalica/features/app_state_init/data/models/game_room_model.dart';
import 'package:slagalica/features/game_room/data/data_sources/remote/game_room_api_service.dart';
import 'package:slagalica/features/game_room/domain/repository/game_room_repository.dart';

class GameRoomRepositoryImplementation implements GameRoomRepository {
  final GameRoomApiService dataSource;

  GameRoomRepositoryImplementation({required this.dataSource});

  @override
  Future<void> leaveRoom(GameRoomModel room, String username) async {
    return await dataSource.leaveRoom(room, username);
  }
}
