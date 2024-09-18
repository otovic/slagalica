import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slagalica/core/services/firebase_auth_service.dart';
import 'package:slagalica/features/auth/data/models/auth_model.dart';
import 'package:slagalica/features/auth/data/models/auth_status.dart';
import 'package:slagalica/features/auth/domain/entities/auth_exceptions.dart';
import 'package:slagalica/features/auth/domain/entities/image_source.dart';
import 'package:slagalica/features/auth/domain/entities/sign_in_entity.dart';
import 'package:slagalica/features/auth/domain/usecases/abort_registration.dart';
import 'package:slagalica/features/auth/domain/usecases/pick_image_gallery.dart';
import 'package:slagalica/features/auth/domain/usecases/register.dart';
import 'package:slagalica/features/auth/domain/usecases/sign_in.dart';
import 'package:slagalica/features/auth/presentation/bloc/auth_event.dart';
import 'package:slagalica/features/auth/presentation/bloc/auth_state.dart';
import 'package:slagalica/shared/services/validator/validator_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUseCase _registerUseCase;
  final PickImageGalleryUseCase _pickImageGalleryUseCase;
  final SignInUseCase _signInUseCase;

  AuthBloc(
    this._registerUseCase,
    this._pickImageGalleryUseCase,
    this._signInUseCase,
  ) : super(AuthStateIdle(data: AuthModel.empty())) {
    on<AuthRegisterEvent>(_register);
    on<AuthImagePickedEvent>(_imagePicked);
    on<UsernameChangedEvent>(_usernameChanged);
    on<EmailChangedEvent>(_emailChanged);
    on<PasswordChangedEvent>(_passwordChanged);
    on<ConfirmPasswordChangedEvent>(_confirmPasswordChanged);
    on<SignInEvent>(_signIn);
  }

  _imagePicked(AuthImagePickedEvent event, Emitter<AuthState> emit) async {
    try {
      String? image;
      if (event.source == EImageSource.gallery) {
        image = await _pickImageGalleryUseCase.call();
      } else {
        image = await _pickImageGalleryUseCase.call();
      }
      if (image == null) return;
      emit(AuthStateIdle(data: state.data.copyWith(image: image)));
    } catch (e) {
      print("Error: $e");
      emit(AuthStateError(
          error: EAuthStatus.unknown,
          data: state.data,
          message: "Došlo je do greške"));
    }
  }

  _usernameChanged(UsernameChangedEvent event, Emitter<AuthState> emit) {
    emit(AuthStateIdle(data: state.data.copyWith(username: event.username)));
  }

  _emailChanged(EmailChangedEvent event, Emitter<AuthState> emit) {
    emit(AuthStateIdle(data: state.data.copyWith(email: event.email)));
  }

  _passwordChanged(PasswordChangedEvent event, Emitter<AuthState> emit) {
    emit(AuthStateIdle(data: state.data.copyWith(password: event.password)));
  }

  _confirmPasswordChanged(
      ConfirmPasswordChangedEvent event, Emitter<AuthState> emit) {
    emit(AuthStateIdle(
        data: state.data.copyWith(confirmPassword: event.confirmPassword)));
  }

  Future<void> _register(
      AuthRegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthStateLoading(data: state.data));
    await Future.delayed(const Duration(seconds: 1));
    try {
      _checkIfFieldsAreValid(state.data);
      await _registerUseCase.call(state.data.copyWith(
        deviceID: event.deviceID,
        deviceModel: event.deviceModel,
      ));
      emit(AuthStateRegister(data: state.data));
    } on FirebaseAuthException catch (e) {
      print("Error: $e");
      emit(AuthStateError(
          error: EAuthStatus.unknown,
          data: state.data,
          message: FirebaseAuthService.parseAuthExceptionCode(e.code)));
    } on AuthException catch (e) {
      print("Error: $e");
      emit(AuthStateError(
          error: EAuthStatus.unknown, data: state.data, message: e.message));
    } catch (e) {
      print("Error: $e");
      emit(AuthStateError(
          error: EAuthStatus.unknown,
          data: state.data,
          message: "Došlo je do greške"));
    }
  }

  Future<void> _signIn(SignInEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthStateLoading(data: state.data));
      if (event.email.isEmpty || event.password.isEmpty) {
        throw AuthException("Sva polja moraju biti popunjena");
      }
      await _signInUseCase.call(SignInEntity(
        email: event.email,
        password: event.password,
      ));
      emit(AuthStateSignedIn(data: state.data));
    } on FirebaseAuthException catch (e) {
      print("Error: ${e.code}");
      emit(AuthStateError(
          error: EAuthStatus.unknown,
          data: state.data,
          message: FirebaseAuthService.parseAuthExceptionCode(e.code)));
    } on AuthException catch (e) {
      print("Error: $e");
      emit(AuthStateError(
          error: EAuthStatus.fieldsEmpty,
          data: state.data,
          message: e.message));
    } catch (e) {
      print("Error: $e");
      emit(AuthStateError(
          error: EAuthStatus.unknown,
          data: state.data,
          message: "Došlo je do greške"));
    }
  }

  _checkIfFieldsAreValid(AuthModel data) {
    if (data.username.isEmpty ||
        data.email.isEmpty ||
        data.password.isEmpty ||
        data.confirmPassword.isEmpty) {
      throw AuthException("Sva polja moraju biti popunjena");
    }
    if (data.password != data.confirmPassword) {
      throw AuthException("Lozinke se ne poklapaju");
    }
  }
}
