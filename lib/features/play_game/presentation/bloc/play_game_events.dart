part of 'play_game_bloc.dart';

abstract class PlayGameEvent {
  const PlayGameEvent();
}

class FinishedLoadingEvent extends PlayGameEvent {
  const FinishedLoadingEvent();
}

class SyncDataEvent extends PlayGameEvent {
  final GameRoomModel gameRoom;
  const SyncDataEvent(this.gameRoom);
}

class SyncTimerEvent extends PlayGameEvent {
  final int time;
  final int turn;
  const SyncTimerEvent(this.time, this.turn);
}

class InitTimerEvent extends PlayGameEvent {
  GameTimer gameTimer;
  InitTimerEvent(this.gameTimer);
}

class SetTimerEvent extends PlayGameEvent {
  final GameTimer gameTimer;
  SetTimerEvent(this.gameTimer);
}
