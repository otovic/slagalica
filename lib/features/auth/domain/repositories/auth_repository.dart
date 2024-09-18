import 'package:image_picker/image_picker.dart';
import 'package:slagalica/features/auth/data/models/auth_sign_in_model.dart';
import 'package:slagalica/features/auth/data/models/auth_status.dart';
import 'package:slagalica/features/auth/domain/entities/auth_entity.dart';
import 'package:slagalica/features/auth/domain/entities/sign_in_entity.dart';

abstract class AuthRepository {
  Future<void> register(AuthEntity data);
  Future<String?> pickImageGallery();
  Future<String?> pickImageCamera();
  void abortRegistration(AuthEntity data);
  Future<void> signIn(SignInEntity data);
}
