part of 'skocko_bloc.dart';

abstract class SkockoEvent {
  const SkockoEvent();
}

class SkockoSyncDataEvent extends SkockoEvent {
  const SkockoSyncDataEvent();
}

class SkockoRestartGameEvent extends SkockoEvent {
  const SkockoRestartGameEvent();
}

class SkockoInitCombinationEvent extends SkockoEvent {
  const SkockoInitCombinationEvent();
}

class SkockoAddSignEvent extends SkockoEvent {
  final int index;

  const SkockoAddSignEvent(this.index);
}

class SkockoRemoveSignEvent extends SkockoEvent {
  const SkockoRemoveSignEvent();
}

class SkockoSubmitCombinationEvent extends SkockoEvent {
  const SkockoSubmitCombinationEvent();
}

class SkockoEndGameCorrectEvent extends SkockoEvent {
  const SkockoEndGameCorrectEvent();
}

class SkockoStartTimerEvent extends SkockoEvent {
  const SkockoStartTimerEvent();
}

class SkockoSubmitOverEvent extends SkockoEvent {
  const SkockoSubmitOverEvent();
}

class SkockoOponnentTurnEvent extends SkockoEvent {
  const SkockoOponnentTurnEvent();
}

class SkockoSubmitOponnentCombinationEvent extends SkockoEvent {
  const SkockoSubmitOponnentCombinationEvent();
}
