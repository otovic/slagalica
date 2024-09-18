abstract class MojBrojEvent {
  const MojBrojEvent();
}

class MojBrojStartNumberShuffle extends MojBrojEvent {
  const MojBrojStartNumberShuffle();
}

class MojBrojRestartGameEvent extends MojBrojEvent {
  const MojBrojRestartGameEvent();
}

class MojBrojSyncEvent extends MojBrojEvent {
  const MojBrojSyncEvent();
}

class MojBrojChooseNumbersEvent extends MojBrojEvent {
  const MojBrojChooseNumbersEvent();
}

class MojBrojCalculateEvent extends MojBrojEvent {
  const MojBrojCalculateEvent();
}

class MojBrojAddCalculationEvent extends MojBrojEvent {
  final String expression;
  final int index;

  const MojBrojAddCalculationEvent({
    required this.expression,
    required this.index,
  });
}

class MojBrojRemoveCalculationEvent extends MojBrojEvent {
  const MojBrojRemoveCalculationEvent();
}

class MojBrojSubmitExpressionEvent extends MojBrojEvent {
  const MojBrojSubmitExpressionEvent();
}

class MojBrojEndGameEvent extends MojBrojEvent {
  const MojBrojEndGameEvent();
}
