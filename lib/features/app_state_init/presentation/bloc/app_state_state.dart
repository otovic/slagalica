import 'package:slagalica/config/data/device_type.dart';
import 'package:slagalica/features/app_state_init/data/models/app_state_model.dart';
import 'package:slagalica/features/app_state_init/data/models/game_room_model.dart';

abstract class AppStateState {
  final AppStateModel? data;

  AppStateState({required this.data});
}

class AppStateUninitialized extends AppStateState {
  AppStateUninitialized()
      : super(
          data: AppStateModel(
              initialized: false,
              context: null,
              OS: "unknown",
              deviceType: EDeviceType.unknown,
              user: null,
              snackBarActive: false,
              userData: null,
              androidDeviceInfo: null,
              iOSDeviceInfo: null,
              storageData: null),
        );
}

class AppStateInitializedData extends AppStateState {
  AppStateInitializedData(AppStateModel data) : super(data: data);
}

class AppStateInitializedUser extends AppStateState {
  AppStateInitializedUser(AppStateModel data) : super(data: data);
}

class AppStateError extends AppStateState {
  AppStateError()
      : super(
          data: AppStateModel(
              initialized: false,
              context: null,
              OS: 'error',
              deviceType: EDeviceType.unknown,
              user: null,
              snackBarActive: false),
        );
}

class AppStateCreatingRoom extends AppStateInitializedUser {
  AppStateCreatingRoom(AppStateModel data) : super(data);
}

class AppStateCreateRoomError extends AppStateInitializedUser {
  final String message;
  AppStateCreateRoomError(this.message, AppStateModel data) : super(data);
}

class AppStateRoomCreated extends AppStateInitializedUser {
  late final GameRoomModel gameRoom;
  AppStateRoomCreated(this.gameRoom, AppStateModel data) : super(data);
}

class AppStateJoiningRoom extends AppStateInitializedUser {
  AppStateJoiningRoom(AppStateModel data) : super(data);
}

class AppStateRoomJoined extends AppStateInitializedUser {
  late final GameRoomModel gameRoom;
  AppStateRoomJoined(this.gameRoom, AppStateModel data) : super(data);
}

class AppStateRoomJoinError extends AppStateInitializedUser {
  final String message;
  AppStateRoomJoinError(this.message, AppStateModel data) : super(data);
}
