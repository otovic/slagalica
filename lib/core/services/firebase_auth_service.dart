import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:slagalica/core/resources/user_data_model.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> createUserWithEmailAndPassword(
      final String email, final String password, final String? imageURL) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return userCredential;
  }

  Future<void> createUserFirestoreDocument(
      final String username,
      final String uid,
      final String? imageURL,
      final String deviceID,
      final String deviceModel) async {
    await _firestore.collection('users').doc(uid).set(
          UserDataModel.initial(
            username: username,
            imageURL: imageURL,
            deviceID: deviceID,
            deviceModel: deviceModel,
          ).toJson(),
        );
  }

  Future<void> deleteUser() async {
    final uid = _firebaseAuth.currentUser!.uid;
    await _deleteUserFirestoreDocument(uid);
    await _firebaseAuth.currentUser!.delete();
  }

  Future<void> _deleteUserFirestoreDocument(final String uid) async {
    await _firestore.collection('users').doc(uid).delete();
  }

  getUserUid() {
    return _firebaseAuth.currentUser!.uid;
  }

  static parseAuthExceptionCode(final String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Email je već u upotrebi';
      case 'user-not-found':
        return 'Korisnik nije pronađen';
      case 'wrong-password':
        return 'Pogrešna lozinka';
      case 'invalid-credential':
        return 'Netačan email ili lozinka';
      case 'too-many-requests':
        return 'Previse pokušaja, pokušajte ponovo kasnije';
      default:
        return 'Došlo je do greške';
    }
  }
}
