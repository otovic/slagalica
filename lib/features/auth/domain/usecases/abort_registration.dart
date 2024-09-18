import 'package:slagalica/core/usecases/use_case.dart';
import 'package:slagalica/features/auth/data/models/auth_model.dart';
import 'package:slagalica/features/auth/domain/repositories/auth_repository.dart';

class AbortRegistrationUseCase extends UseCaseWithParams<void, AuthModel> {
  final AuthRepository repository;

  AbortRegistrationUseCase(this.repository);

  @override
  Future<void> call(AuthModel data) async {
    return repository.abortRegistration(data);
  }
}
