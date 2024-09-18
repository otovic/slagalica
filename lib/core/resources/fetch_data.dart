import 'package:slagalica/core/resources/error.dart';

abstract class FetchData<T> {
  final T? data;
  final FetchDataError? error;

  const FetchData(this.data, this.error);
}

class FetchDataSuccess<T> extends FetchData<T> {
  const FetchDataSuccess(T data) : super(data, null);
}

class FetchDataError<T> extends FetchData<T> {
  const FetchDataError(T? data) : super(data, null);
}
