import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(
      final String remotePath, final String localPath) async {
    final ref = _storage.ref().child(remotePath);
    final file = await ref.putFile(File(localPath));
    return await file.ref.getDownloadURL();
  }

  Future<void> removeUserImage(final String uid) async {
    await _storage.ref().child("users/${uid}/profile").delete();
  }
}
