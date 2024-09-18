import 'package:slagalica/core/usecases/use_case.dart';
import 'package:slagalica/features/app_state_init/data/repositories/game_room_repository_implementation.dart';

class DeleteRoomUseCase extends UseCaseWithParams<void, String> {
  final GameRoomStateRepositoryImplementation _gameRoomRepositoryInplementation;

  DeleteRoomUseCase(this._gameRoomRepositoryInplementation);

  @override
  Future<void> call(String params) {
    return _gameRoomRepositoryInplementation.deleteRoom(params);
  }
}
