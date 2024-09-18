import 'package:slagalica/core/usecases/use_case.dart';
import 'package:slagalica/features/auth/data/models/auth_sign_in_model.dart';
import 'package:slagalica/features/auth/domain/entities/sign_in_entity.dart';
import 'package:slagalica/features/auth/domain/repositories/auth_repository.dart';

class SignInUseCase extends UseCaseWithParams<void, SignInEntity> {
  final AuthRepository _repository;

  SignInUseCase(this._repository);

  @override
  Future<void> call(SignInEntity params) async {
    return await _repository.signIn(SignInModel.fromEntity(params));
  }
}
