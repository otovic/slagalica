part of validator_service;

abstract class _IValidatorServiceRepository {
  bool isEmailValid(String email);
  bool isUsernameValid(String username);
  bool isPasswordValid(String password);
}
