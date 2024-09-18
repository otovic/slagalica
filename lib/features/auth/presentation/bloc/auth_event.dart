import 'package:slagalica/features/app_state_init/presentation/bloc/app_state_bloc.dart';
import 'package:slagalica/features/auth/domain/entities/image_source.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class AuthImagePickedEvent extends AuthEvent {
  final EImageSource source;
  AuthImagePickedEvent({required this.source});
}

class UsernameChangedEvent extends AuthEvent {
  final String username;

  UsernameChangedEvent(this.username);
}

class EmailChangedEvent extends AuthEvent {
  final String email;

  EmailChangedEvent(this.email);
}

class PasswordChangedEvent extends AuthEvent {
  final String password;

  PasswordChangedEvent(this.password);
}

class ConfirmPasswordChangedEvent extends AuthEvent {
  final String confirmPassword;

  ConfirmPasswordChangedEvent(this.confirmPassword);
}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;
  SignInEvent(this.email, this.password);
}

class AuthRegisterEvent extends AuthEvent {
  final String deviceID;
  final String deviceModel;
  AuthRegisterEvent(this.deviceID, this.deviceModel);
}
