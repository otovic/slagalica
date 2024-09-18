import 'package:slagalica/core/usecases/use_case.dart';

class ValidatePasswordUseCase extends UseCaseWithParams<bool, String> {
  @override
  Future<bool> call(String password) async {
    return password.length >= 6;
  }
}
