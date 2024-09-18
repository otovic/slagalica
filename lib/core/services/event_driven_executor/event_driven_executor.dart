library event_driven_executor;

part 'package:slagalica/core/services/event_driven_executor/executor_event.dart';
part 'package:slagalica/core/services/event_driven_executor/event_executor_state.dart';

mixin EventDrivenExecutor<T> {
  List<ExecutorEvent<T>> _events = [];

  void addExecutorEvent(ExecutorEvent<T> event) {
    for (ExecutorEvent eevent in _events) {
      if (eevent.name == event.name) {
        print("POSTOJI");
        return;
      }
    }
    _events.add(event);
  }

  void fireEvent(T state) {
    _events.forEach((event) {
      if (event.getEventName(state) == event.name) {
        event.callback(state);
      }
    });
  }
}

class EventNotFoundException implements Exception {
  final String message;

  EventNotFoundException(this.message);
}
