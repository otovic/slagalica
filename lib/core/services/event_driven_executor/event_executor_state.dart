part of 'event_driven_executor.dart';

abstract class EventExecutorState<T> {
  T data;

  EventExecutorState({required this.data});
}
