library validator_service;

part 'package:slagalica/shared/services/validator/validator_service_repository.dart';

class ValidatorService implements _IValidatorServiceRepository {
  @override
  bool isPasswordValid(String password) {
    return password.length >= 8;
  }

  @override
  bool isUsernameValid(String username) {
    return username.length <= 40 && username.length >= 3;
  }

  @override
  bool isEmailValid(String email) {
    const pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final regex = RegExp(pattern);
    return regex.hasMatch(email);
  }
}
