import 'package:image_picker/image_picker.dart';
import 'package:slagalica/core/usecases/use_case.dart';
import 'package:slagalica/features/auth/domain/repositories/auth_repository.dart';

class PickImageGalleryUseCase extends UseCaseNoParams<String?> {
  final AuthRepository repository;

  PickImageGalleryUseCase(this.repository);

  @override
  Future<String?> call() async {
    return await repository.pickImageGallery();
  }
}
