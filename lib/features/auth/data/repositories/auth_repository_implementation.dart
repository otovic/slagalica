import 'package:image_picker/image_picker.dart';
import 'package:slagalica/features/auth/data/data_sources/auth_api_service.dart';
import 'package:slagalica/features/auth/data/models/auth_model.dart';
import 'package:slagalica/features/auth/data/models/auth_sign_in_model.dart';
import 'package:slagalica/features/auth/data/models/auth_status.dart';
import 'package:slagalica/features/auth/domain/entities/auth_entity.dart';
import 'package:slagalica/features/auth/domain/entities/sign_in_entity.dart';
import 'package:slagalica/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImplementation implements AuthRepository {
  final AuthApiService _apiService;

  AuthRepositoryImplementation(this._apiService);

  @override
  Future<void> register(AuthEntity data) async {
    return await _apiService.register(AuthModel.fromEntity(data));
  }

  @override
  Future<String?> pickImageGallery() {
    return _apiService.pickImageGallery();
  }

  @override
  Future<String?> pickImageCamera() {
    return _apiService.pickImageCamera();
  }

  @override
  void abortRegistration(AuthEntity data) {
    _apiService.abortRegistration(AuthModel.fromEntity(data));
  }

  @override
  Future<void> signIn(SignInEntity data) {
    return _apiService.signIn(SignInModel.fromEntity(data));
  }
}
