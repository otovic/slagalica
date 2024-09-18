import 'dart:io' show Platform;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:slagalica/config/data/device_type.dart';
import 'package:slagalica/core/services/local_storage.dart';
import 'package:slagalica/features/app_state_init/data/models/app_state_model.dart';

class AppStateInitApiService {
  Future<AppStateModel> init(BuildContext context) async {
    String OS = Platform.operatingSystem;
    double width = MediaQuery.of(context).size.width;
    AndroidDeviceInfo? androidDeviceInfo;
    IosDeviceInfo? iOSDeviceInfo;
    StorageData? storageData;

    if (OS == 'android') {
      androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    } else {
      iOSDeviceInfo = await DeviceInfoPlugin().iosInfo;
    }

    try {
      storageData = StorageData();
      await storageData.init();
    } catch (e) {
      print("App State Service: Error initializing storage data: $e");
    }

    return AppStateModel(
      initialized: true,
      context: context,
      OS: OS,
      deviceType: getDeviceType(width),
      user: null,
      androidDeviceInfo: androidDeviceInfo,
      iOSDeviceInfo: iOSDeviceInfo,
      storageData: storageData,
    );
  }

  EDeviceType getDeviceType(double width) {
    if (width > 1200) {
      return EDeviceType.desktop;
    } else if (width > 600) {
      return EDeviceType.tablet;
    } else {
      return EDeviceType.mobile;
    }
  }
}
