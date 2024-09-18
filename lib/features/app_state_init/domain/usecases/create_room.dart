import 'package:slagalica/core/usecases/use_case.dart';
import 'package:slagalica/features/app_state_init/data/models/game_room_model.dart';
import 'package:slagalica/features/app_state_init/data/repositories/game_room_repository_implementation.dart';
import 'package:slagalica/features/app_state_init/domain/entities/player_entity.dart';

class CreateRoomUseCase extends UseCaseWithParams<GameRoomModel, PlayerEntity> {
  final GameRoomStateRepositoryImplementation _gameRoomRepositoryInplementation;

  CreateRoomUseCase(this._gameRoomRepositoryInplementation);

  @override
  Future<GameRoomModel> call(PlayerEntity player1) {
    return _gameRoomRepositoryInplementation.createRoom(player1);
  }
}
