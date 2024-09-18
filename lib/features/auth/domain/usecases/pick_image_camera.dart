import 'package:slagalica/core/usecases/use_case.dart';
import 'package:slagalica/features/auth/domain/repositories/auth_repository.dart';

class PickImageCameraUseCase extends UseCaseNoParams<String?> {
  final AuthRepository repository;

  PickImageCameraUseCase(this.repository);

  @override
  Future<String?> call() async {
    return await repository.pickImageCamera();
  }
}
