import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slagalica/config/theme/app_bar/app_bar_theme.dart';
import 'package:slagalica/config/theme/styles/text_styles.dart';
import 'package:slagalica/dependency_injector.dart';
import 'package:slagalica/features/app_state_init/presentation/bloc/app_state_bloc.dart';
import 'package:slagalica/features/app_state_init/presentation/bloc/app_state_event.dart';
import 'package:slagalica/features/app_state_init/presentation/pages/app_state_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  await InitializeDependencies();
  runApp(const Slagalica());
}

class Slagalica extends StatelessWidget {
  const Slagalica({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.blue,
        statusBarColor: Colors.transparent,
      ),
    );

    return BlocProvider<AppStateBloc>(
      create: (context) => di(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: appBarTheme,
          textTheme: const TextTheme(
            bodySmall: AppTextStyles.small,
            bodyMedium: AppTextStyles.medium,
            bodyLarge: AppTextStyles.large,
            headlineSmall: AppTextStyles.headlineSmall,
            headlineMedium: AppTextStyles.headlineMedium,
            headlineLarge: AppTextStyles.headlineLarge,
          ),
        ),
        home: Builder(
          builder: (context) {
            return AppStatePage();
          },
        ),
      ),
    );
  }
}
