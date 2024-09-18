import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slagalica/core/resources/user_data_model.dart';
import 'package:slagalica/features/auth/domain/entities/auth_exceptions.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> deleteUser(final String uid) async {
    await _firestore.collection('users').doc(uid).delete();
  }

  _parseExceptionCode(final String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Email je već u upotrebi';
      case 'user-not-found':
        return 'Korisnik nije pronađen';
      case 'wrong-password':
        return 'Pogrešna lozinka';
      default:
        return 'Došlo je do greške';
    }
  }

  Future<String> generateRoomID() async {
    final String characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    final String roomID = List.generate(7,
            (index) => characters[DateTime.now().microsecondsSinceEpoch % 36])
        .join();

    final snapshot = await _firestore.collection('rooms').doc(roomID).get();
    while (snapshot.exists) {
      return await generateRoomID();
    }

    return roomID;
  }
}
