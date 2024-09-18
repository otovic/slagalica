import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:slagalica/config/data/device_type.dart';
import 'package:slagalica/core/resources/user_data_model.dart';
import 'package:slagalica/core/services/local_storage.dart';
import 'package:slagalica/features/app_state_init/domain/entities/app_state_entity.dart';

class AppStateModel extends AppStateEntity {
  final bool initialized;
  final BuildContext? context;
  final String OS;
  final User? user;
  final EDeviceType deviceType;
  bool snackBarActive = false;
  UserDataModel? userData;
  AndroidDeviceInfo? androidDeviceInfo;
  IosDeviceInfo? iOSDeviceInfo;
  StorageData? storageData;

  AppStateModel({
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
  }) : super(
          initialized: initialized,
          context: context,
          OS: OS,
          deviceType: deviceType,
          user: user,
          snackBarActive: snackBarActive,
          userData: userData,
          androidDeviceInfo: androidDeviceInfo,
          iOSDeviceInfo: iOSDeviceInfo,
          storageData: storageData,
        );

  factory AppStateModel.fromEntity(AppStateEntity entity) {
    return AppStateModel(
      initialized: entity.initialized,
      context: entity.context,
      OS: entity.OS,
      deviceType: entity.deviceType,
      user: entity.user,
      snackBarActive: entity.snackBarActive,
      userData: entity.userData,
      androidDeviceInfo: entity.androidDeviceInfo,
      iOSDeviceInfo: entity.iOSDeviceInfo,
      storageData: entity.storageData,
    );
  }

  AppStateModel copyWith({
    bool? initialized,
    BuildContext? context,
    String? OS,
    User? user,
    EDeviceType? deviceType,
    bool? snackBarActive,
    UserDataModel? userData,
    AndroidDeviceInfo? androidDeviceInfo,
    IosDeviceInfo? iOSDeviceInfo,
    StorageData? storageData,
  }) {
    return AppStateModel(
      initialized: initialized ?? this.initialized,
      context: context ?? this.context,
      OS: OS ?? this.OS,
      deviceType: deviceType ?? this.deviceType,
      user: user ?? this.user,
      snackBarActive: snackBarActive ?? this.snackBarActive,
      userData: userData ?? this.userData,
      androidDeviceInfo: androidDeviceInfo ?? this.androidDeviceInfo,
      iOSDeviceInfo: iOSDeviceInfo ?? this.iOSDeviceInfo,
      storageData: storageData ?? this.storageData,
    );
  }
}
