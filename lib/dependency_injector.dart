import 'package:get_it/get_it.dart';
import 'package:slagalica/core/services/firebase_auth_service.dart';
import 'package:slagalica/core/services/firebase_storage_service.dart';
import 'package:slagalica/core/services/firestore_service.dart';
import 'package:slagalica/features/app_state_init/data/data_sources/local/app_state_init_api_service.dart';
import 'package:slagalica/features/app_state_init/data/data_sources/remote/game_room_state_api_service.dart';
import 'package:slagalica/features/app_state_init/data/repositories/app_state_repository_implementation.dart';
import 'package:slagalica/features/app_state_init/data/repositories/game_room_repository_implementation.dart';
import 'package:slagalica/features/app_state_init/domain/repository/app_state_repository.dart';
import 'package:slagalica/features/app_state_init/domain/usecases/create_room.dart';
import 'package:slagalica/features/app_state_init/domain/usecases/delete_room.dart';
import 'package:slagalica/features/app_state_init/domain/usecases/init_app_state.dart';
import 'package:slagalica/features/app_state_init/domain/usecases/join_room.dart';
import 'package:slagalica/features/app_state_init/presentation/bloc/app_state_bloc.dart';
import 'package:slagalica/features/auth/data/data_sources/auth_api_service.dart';
import 'package:slagalica/features/auth/data/repositories/auth_repository_implementation.dart';
import 'package:slagalica/features/auth/domain/repositories/auth_repository.dart';
import 'package:slagalica/features/auth/domain/usecases/abort_registration.dart';
import 'package:slagalica/features/auth/domain/usecases/pick_image_gallery.dart';
import 'package:slagalica/features/auth/domain/usecases/register.dart';
import 'package:slagalica/features/auth/domain/usecases/sign_in.dart';
import 'package:slagalica/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:slagalica/features/buy_coins/data/data_sources/remote/iap_api_service.dart';
import 'package:slagalica/features/buy_coins/data/repositories/iap_repository_implementation.dart';
import 'package:slagalica/features/buy_coins/domain/usecases/make_purchase.dart';
import 'package:slagalica/features/buy_coins/domain/usecases/process_purchase.dart';
import 'package:slagalica/features/buy_coins/presentation/bloc/buy_coins_bloc.dart';
import 'package:slagalica/features/game_room/data/data_sources/remote/game_room_api_service.dart';
import 'package:slagalica/features/game_room/data/repositories/game_room_repository_implementation.dart';
import 'package:slagalica/features/game_room/domain/usecases/leave_room_use_case.dart';
import 'package:slagalica/shared/services/validator/validator_service.dart';

final di = GetIt.instance;

Future<void> InitializeDependencies() async {
  //Shared services
  di.registerSingleton(FirebaseStorageService());
  di.registerSingleton(FirestoreService());
  di.registerSingleton(FirebaseAuthService());

  di.registerSingleton(AppStateInitApiService());
  di.registerSingleton<AppStateRepository>(
    AppStateRepositoryImplementation(di()),
  );

  //Auth page
  di.registerSingleton(GameRoomStateApiService());
  di.registerSingleton(GameRoomStateRepositoryImplementation(di()));
  di.registerSingleton<AppStateInitUseCase>(
    AppStateInitUseCase(di()),
  );
  di.registerSingleton(DeleteRoomUseCase(di()));
  di.registerSingleton(JoinRoomUseCase(di()));
  di.registerFactory(
    () => AppStateBloc(di(), di(), di(), di()),
  );
  di.registerSingleton(ValidatorService());
  di.registerSingleton(AuthApiService(di(), di()));
  di.registerSingleton<AuthRepository>(
    AuthRepositoryImplementation(di()),
  );
  di.registerSingleton(CreateRoomUseCase(di()));

  //Game Room Page
  di.registerSingleton(GameRoomApiService());
  di.registerSingleton(GameRoomRepositoryImplementation(dataSource: di()));
  di.registerSingleton(LeaveRoomUseCase(di()));

  //Buy Coins Page
  di.registerSingleton(IapApiService(di()));
  di.registerSingleton(IapRepositoryImplementation(di()));
  di.registerSingleton(MakePurchaseUseCase(di()));
  di.registerSingleton(ProcessPurchaseUseCase(di()));
  di.registerFactory(
    () => BuyCoinsBloc(
      makePurchaseUseCase: di(),
      processPurchaseUseCase: di(),
      appStateBloc: di(),
    ),
  );

  di.registerSingleton(
    RegisterUseCase(di()),
  );
  di.registerSingleton(AbortRegistrationUseCase(di()));
  di.registerSingleton(PickImageGalleryUseCase(di()));
  di.registerSingleton(SignInUseCase(di()));
  di.registerFactory(
    () => AuthBloc(
      di(),
      di(),
      di(),
    ),
  );
}
