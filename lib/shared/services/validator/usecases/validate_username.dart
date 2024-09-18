import 'package:slagalica/core/usecases/use_case.dart';
import 'package:slagalica/shared/services/validator/validator_service.dart';

class ValidateUsernameUseCase extends UseCaseWithParams<bool, String> {
  @override
  Future<bool> call(String username) async {
    return ValidatorService().isUsernameValid(username);
  }
}
