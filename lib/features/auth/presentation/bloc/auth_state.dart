import 'package:slagalica/features/auth/data/models/auth_model.dart';
import 'package:slagalica/features/auth/data/models/auth_status.dart';

abstract class AuthState {
  AuthModel data;
  AuthState({
    required this.data,
  });
}

class AuthStateIdle extends AuthState {
  AuthStateIdle({required AuthModel data}) : super(data: data);
}

class AuthStateLoading extends AuthState {
  AuthStateLoading({required data}) : super(data: data);
}

class AuthStateUsernameError extends AuthState {
  AuthStateUsernameError({required data, required confirmedPassword})
      : super(data: data);
}

class AuthStateRegister extends AuthState {
  AuthStateRegister({required data}) : super(data: data);
}

class AuthStateSignedIn extends AuthState {
  AuthStateSignedIn({required data}) : super(data: data);
}

class AuthStateError extends AuthState {
  final EAuthStatus error;
  final String message;

  AuthStateError({required this.error, required data, required this.message})
      : super(data: data);
}
