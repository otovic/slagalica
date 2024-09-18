import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slagalica/dependency_injector.dart';
import 'package:slagalica/features/app_state_init/presentation/bloc/app_state_bloc.dart';
import 'package:slagalica/features/app_state_init/presentation/bloc/app_state_event.dart';
import 'package:slagalica/features/app_state_init/presentation/bloc/app_state_state.dart';
import 'package:slagalica/features/app_state_init/presentation/widgets/app_state_loading.dart';
import 'package:slagalica/features/auth/presentation/pages/auth_select_page.dart';
import 'package:slagalica/features/main_menu/presentation/pages/main_menu_page.dart';

class AppStatePage extends StatelessWidget {
  AppStatePage({super.key});
  late AppStateBloc appStateBloc;

  @override
  Widget build(BuildContext context) {
    appStateBloc = BlocProvider.of<AppStateBloc>(context);
    return _buildBody(context);
  }

  _buildBody(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: BlocBuilder<AppStateBloc, AppStateState>(
          bloc: appStateBloc,
          builder: (context, state) {
            if (state is AppStateUninitialized) {
              appStateBloc.add(AppStateInitEvent(context));
              return const Center(child: AppStateLoading());
            } else if (state is AppStateInitializedUser) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => () {
                      if (state.data!.user == null) {
                        return const AuthSelectPage();
                      } else {
                        return MainMenuPage();
                      }
                    }(),
                  ),
                );
              });
              print('AppStateInitializedUser');
              return const Center(child: AppStateLoading());
            } else if (state is AppStateError) {
              return const Center(
                child: Text('Error'),
              );
            } else {
              return const Center(child: AppStateLoading());
            }
          },
        ),
      ),
    );
  }
}
