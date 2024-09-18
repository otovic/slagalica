abstract class GameRoomException {}

class GameRoomJoinException implements GameRoomException {
  final String message;

  GameRoomJoinException(this.message);
}

class GameRoomJoinRoomFullException implements GameRoomException {
  final String message;

  GameRoomJoinRoomFullException(this.message);
}
