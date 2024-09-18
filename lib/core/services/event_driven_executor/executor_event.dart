part of 'event_driven_executor.dart';

abstract class ExecutorEvent<T> {
  final String name;
  final Function callback;
  final int? execution;

  ExecutorEvent({
    required this.name,
    required this.callback,
    this.execution,
  });

  String getEventName(T state);
}
