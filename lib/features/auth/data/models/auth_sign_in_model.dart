import 'package:slagalica/features/auth/domain/entities/sign_in_entity.dart';

class SignInModel extends SignInEntity {
  late final String email;
  late final String password;

  SignInModel({
    required this.email,
    required this.password,
  }) : super(
          email: email,
          password: password,
        );

  factory SignInModel.fromEntity(SignInEntity entity) {
    return SignInModel(
      email: entity.email,
      password: entity.password,
    );
  }

  SignInModel copyWith({
    String? email,
    String? password,
  }) {
    return SignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
