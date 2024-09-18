part of 'play_game_bloc.dart';

abstract class PlayGameState {
  const PlayGameState();
}

class PlayGameLoadingState extends PlayGameState {
  const PlayGameLoadingState();
}

class PlayGameLoadedState extends PlayGameState {
  final GameRoomModel gameRoom;
  final GameEntity? currentGame;
  final int? time;
  final int? turn;
  const PlayGameLoadedState(this.gameRoom, this.currentGame,
      {this.time, this.turn});
}
