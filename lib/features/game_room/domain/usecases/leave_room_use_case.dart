import 'package:slagalica/core/usecases/use_case.dart';
import 'package:slagalica/features/game_room/data/repositories/game_room_repository_implementation.dart';
import 'package:slagalica/features/game_room/domain/entities/game_room_credentials.dart';

class LeaveRoomUseCase
    extends UseCaseWithParams<void, GameRoomCredentialsEntity> {
  final GameRoomRepositoryImplementation _gameRoomRepository;

  LeaveRoomUseCase(this._gameRoomRepository);

  Future<void> call(GameRoomCredentialsEntity credentials) async {
    return _gameRoomRepository.leaveRoom(
        credentials.room, credentials.username);
  }
}
