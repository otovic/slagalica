import 'package:slagalica/core/usecases/use_case.dart';
import 'package:slagalica/shared/services/validator/validator_service.dart';

class ValidateEmailUseCase extends UseCaseWithParams<bool, String> {
  @override
  Future<bool> call(String email) async {
    return ValidatorService().isEmailValid(email);
  }
}
