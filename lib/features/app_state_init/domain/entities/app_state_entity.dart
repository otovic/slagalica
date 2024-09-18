import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:slagalica/config/data/device_type.dart';
import 'package:slagalica/core/resources/user_data_model.dart';
import 'package:slagalica/core/services/local_storage.dart';

class AppStateEntity {
  final bool initialized;
  final BuildContext? context;
  final User? user;
  final String OS;
  final EDeviceType deviceType;
  bool snackBarActive = false;
  UserDataModel? userData;
  AndroidDeviceInfo? androidDeviceInfo;
  IosDeviceInfo? iOSDeviceInfo;
  StorageData? storageData;

  AppStateEntity({
    required this.initialized,
    required this.context,
    required this.OS,
    required this.deviceType,
    required this.user,
    this.snackBarActive = false,
    this.userData,
    this.androidDeviceInfo,
    this.iOSDeviceInfo,
    this.storageData,
  });
}
