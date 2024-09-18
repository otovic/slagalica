class AuthEntity {
  final String? image;
  final String username;
  final String email;
  final String password;
  final String confirmPassword;
  final String deviceID;
  final String deviceModel;

  AuthEntity({
    this.image,
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.deviceID,
    required this.deviceModel,
  });
}
