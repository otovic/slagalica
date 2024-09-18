import 'dart:convert';

import 'package:localstorage/localstorage.dart';

class StorageData {
  Map<String, dynamic> _data = {};
  late LocalStorage _localStorage;

  readData() {
    final res = localStorage.getItem('data');
    print("Storage data: $res");
    if (res != null) {
      _data = jsonDecode(res);
    } else {
      print('No data found');
      localStorage.setItem('data', jsonEncode({}));
    }
  }

  putData(String key, dynamic value) {
    _data[key] = value;
    localStorage.setItem('data', jsonEncode(_data));
    print("Storage data updated: $_data");
  }

  dynamic getData(String key) {
    return _data[key];
  }

  Future<void> init() async {
    await initLocalStorage();
    print("Storage data initialized");
    readData();
  }
}
