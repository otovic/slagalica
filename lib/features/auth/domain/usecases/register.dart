import 'package:slagalica/core/usecases/use_case.dart';
import 'package:slagalica/features/auth/data/models/auth_status.dart';
import 'package:slagalica/features/auth/domain/entities/auth_entity.dart';
import 'package:slagalica/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase extends UseCaseWithParams<void, AuthEntity> {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  @override
  Future<void> call(AuthEntity entity) async {
    return await _repository.register(entity);
  }
}
