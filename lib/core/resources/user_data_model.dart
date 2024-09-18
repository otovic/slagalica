import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

class UserDataModel {
  String username = '';
  int coins;
  int wins;
  int losses = 0;
  String imageURL;
  String deviceID;
  String deviceModel;
  String unlimited;

  UserDataModel(
      {required this.username,
      required this.coins,
      required this.wins,
      required this.losses,
      this.imageURL = '',
      required this.deviceID,
      required this.deviceModel,
      this.unlimited = ''});

  factory UserDataModel.initial(
      {required String username,
      String? imageURL,
      required String deviceID,
      required String deviceModel}) {
    return UserDataModel(
        username: username,
        coins: 2,
        losses: 0,
        wins: 0,
        imageURL: imageURL ?? '',
        deviceID: deviceID,
        deviceModel: deviceModel);
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'coins': coins,
      'wins': wins,
      'losses': losses,
      'imageURL': imageURL,
      'deviceID': deviceID,
      'deviceModel': deviceModel,
      'unlimited': unlimited
    };
  }

  static Future<UserDataModel> fetchUserData(final String uid) async {
    UserDataModel data;
    print("Fetching user data for: $uid");
    data = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get(const GetOptions(source: Source.server))
        .then((value) {
      print("Data: ${value.data()}");
      return UserDataModel(
          username: value.data()!['username'],
          coins: value.data()!['coins'],
          wins: value.data()!['wins'],
          losses: value.data()!['losses'],
          imageURL: value.data()!['imageURL'],
          deviceID: value.data()!['deviceID'],
          deviceModel: value.data()!['deviceModel'],
          unlimited: value.data()!['unlimited'] ?? '');
    });

    if (data.unlimited != "") {
      final serverDate =
          await FirebaseFunctions.instanceFor(region: "europe-west1")
              .httpsCallable('getServerTime')();
      print("Server date: ${serverDate.data['date']}");
      List<String> dataSplits = data.unlimited.split("/");
      print("Local date: ${dataSplits}");
      List<String> serverSplits = serverDate.data['date'].split("/");
      final d1 = DateTime(
        int.parse(dataSplits[2]),
        int.parse(dataSplits[1]),
        int.parse(dataSplits[0]),
      );
      print("Local date: ${d1.toString()}");
      final d2 = DateTime(
        int.parse(serverSplits[2]),
        int.parse(serverSplits[1]),
        int.parse(serverSplits[0]),
      );
      print("Server date: ${d2.toString()}");

      if (d2.difference(d1).inDays > 28) {
        print("Unlimited expired");
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .update({'unlimited': ''});
        data.unlimited = '';
      }
    }

    data = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((value) {
      if (!value.exists) {
        throw Exception("User not found");
      }

      return UserDataModel(
          username: value.data()!['username'],
          coins: value.data()!['coins'],
          wins: value.data()!['wins'],
          losses: value.data()!['losses'],
          imageURL: value.data()!['imageURL'],
          deviceID: value.data()!['deviceID'],
          deviceModel: value.data()!['deviceModel']);
    });
    return data;
  }
}
