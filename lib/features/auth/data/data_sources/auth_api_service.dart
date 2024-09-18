import 'package:firebase_auth/firebase_auth.dart';

import 'package:image_picker/image_picker.dart';
import 'package:slagalica/core/services/firebase_auth_service.dart';
import 'package:slagalica/core/services/image_service.dart';
import 'package:slagalica/core/services/firebase_storage_service.dart';
import 'package:slagalica/features/auth/data/models/auth_model.dart';
import 'package:slagalica/features/auth/data/models/auth_sign_in_model.dart';
import 'package:slagalica/features/auth/domain/entities/auth_exceptions.dart';

class AuthApiService {
  final FirebaseStorageService _storageService;
  final FirebaseAuthService _firebaseAuthService;

  AuthApiService(this._storageService, this._firebaseAuthService);

  Future<void> register(AuthModel data) async {
    if (data.deviceID == "" || data.deviceModel == "") {
      throw AuthException("Došlo je do greške prilikom registracije.");
    }

    if (data.image != null && data.image! != "") {
      data.image = await ImageService.resizeImage(data.image!);
    }

    final UserCredential credentials = await _firebaseAuthService
        .createUserWithEmailAndPassword(data.email, data.password, data.image);
    String imageUrl = "";

    if (data.image != null && data.image! != "") {
      imageUrl = await _storageService.uploadImage(
          "users/${credentials.user!.uid}/profile", data.image!);
    }

    await _firebaseAuthService.createUserFirestoreDocument(
      data.username,
      credentials.user!.uid,
      imageUrl,
      data.deviceID,
      data.deviceModel,
    );

    await credentials.user!.updateDisplayName(data.username);
    await credentials.user!.updatePhotoURL(imageUrl);
  }

  Future<String?> pickImageGallery() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) return image.path;
    return null;
  }

  Future<String?> pickImageCamera() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) return image.path;
    return null;
  }

  abortRegistration(AuthModel data) async {
    final uid = _firebaseAuthService.getUserUid();
    _storageService.removeUserImage(uid);
    _firebaseAuthService.deleteUser();
  }

  Future<void> signIn(SignInModel data) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: data.email, password: data.password);
  }
}
