abstract class ErrorMessage {
  final String message;

  const ErrorMessage(this.message);
}

class DataStateError<T> extends ErrorMessage {
  final T? data;

  const DataStateError(this.data, String message) : super(message);
}
