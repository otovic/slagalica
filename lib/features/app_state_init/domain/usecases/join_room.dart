import 'package:slagalica/core/usecases/use_case.dart';
import 'package:slagalica/features/app_state_init/data/models/game_room_model.dart';
import 'package:slagalica/features/app_state_init/data/models/join_room_model.dart';
import 'package:slagalica/features/app_state_init/data/repositories/game_room_repository_implementation.dart';
import 'package:slagalica/features/app_state_init/domain/entities/player_entity.dart';

class JoinRoomUseCase extends UseCaseWithParams<GameRoomModel, JoinRoomModel> {
  final GameRoomStateRepositoryImplementation _gameRoomRepositoryInplementation;

  JoinRoomUseCase(this._gameRoomRepositoryInplementation);

  @override
  Future<GameRoomModel> call(final JoinRoomModel data) {
    return _gameRoomRepositoryInplementation.joinRoom(data);
  }
}
