import 'package:flutter/foundation.dart';
import 'package:slagalica/dependency_injector.dart';
import 'package:slagalica/features/app_state_init/presentation/bloc/app_state_bloc.dart';
import 'package:slagalica/features/auth/domain/entities/auth_entity.dart';

class AuthModel extends AuthEntity {
  String? image;
  late final String username;
  late final String email;
  late final String password;
  late final String confirmPassword;
  late final String deviceID;
  late final String deviceModel;

  AuthModel({
    this.image,
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.deviceID,
    required this.deviceModel,
  }) : super(
          image: image,
          username: username,
          email: email,
          password: password,
          confirmPassword: confirmPassword,
          deviceID: deviceID,
          deviceModel: deviceModel,
        );

  factory AuthModel.fromEntity(AuthEntity entity) {
    return AuthModel(
      image: entity.image,
      username: entity.username,
      email: entity.email,
      password: entity.password,
      confirmPassword: entity.confirmPassword,
      deviceID: entity.deviceID,
      deviceModel: entity.deviceModel,
    );
  }

  factory AuthModel.empty() {
    return AuthModel(
      image: '',
      username: '',
      email: '',
      password: '',
      confirmPassword: '',
      deviceID: '',
      deviceModel: '',
    );
  }

  AuthModel copyWith({
    String? image,
    String? username,
    String? email,
    String? password,
    String? confirmPassword,
    String? deviceID,
    String? deviceModel,
  }) {
    return AuthModel(
      image: image ?? this.image,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      deviceID: deviceID ?? this.deviceID,
      deviceModel: deviceModel ?? this.deviceModel,
    );
  }

  List<Object?> get props => [image, username, email, password];

  @override
  String toString() {
    return 'AuthModel(image: $image, username: $username, email: $email, password: $password, confirmPassword: $confirmPassword)';
  }
}
