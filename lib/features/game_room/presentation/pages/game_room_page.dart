import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slagalica/dependency_injector.dart';
import 'package:slagalica/features/app_state_init/data/models/game_room_model.dart';
import 'package:slagalica/features/app_state_init/presentation/bloc/app_state_bloc.dart';
import 'package:slagalica/features/app_state_init/presentation/bloc/app_state_event.dart';
import 'package:slagalica/features/game_room/presentation/bloc/game_room_bloc.dart';
import 'package:slagalica/features/game_room/presentation/bloc/game_room_event.dart';
import 'package:slagalica/features/game_room/presentation/bloc/game_room_state.dart';
import 'package:slagalica/shared/widgets/button_with_size.dart';
import 'package:slagalica/shared/widgets/player_board.dart';

class GameRoomPage extends StatelessWidget {
  GameRoomPage({super.key, required this.gameRoom});
  final GameRoomModel gameRoom;
  late final AppStateBloc _appStateBloc;
  late final GameRoomBloc _gameRoomBloc;

  @override
  Widget build(BuildContext context) {
    _appStateBloc = BlocProvider.of<AppStateBloc>(context);
    _gameRoomBloc = BlocProvider.of<GameRoomBloc>(context);
    _gameRoomBloc.context = context;

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) {}
      },
      child: BlocProvider<GameRoomBloc>(
        create: (_) => di<GameRoomBloc>(),
        child: Scaffold(
          appBar: _buildAppBar(context),
          body: _buildBody(context),
        ),
      ),
    );
  }

  _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
      title: const Text('Soba'),
    );
  }

  _buildBody(BuildContext context) {
    return BlocBuilder<GameRoomBloc, GameRoomState>(
      bloc: _gameRoomBloc,
      builder: (_, state) {
        if (state is GameRoomDestroyed) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              Navigator.pop(context);
              _appStateBloc.add(
                ShowSnackBarEvent(
                    context: context,
                    duration: const Duration(seconds: 4),
                    message: "Soba je zatvorena"),
              );
            },
          );

          return Container(
            color: Colors.blue,
            child: Center(
              child: CupertinoActivityIndicator(
                  radius: MediaQuery.of(context).size.width * 0.1),
            ),
          );
        }
        if (state is GameRoomUninitialized) {
          _gameRoomBloc.add(GameRoomInitialize(gameRoom));
          return Center(
            child: Container(
              color: Colors.blue,
              child: Center(
                child: CupertinoActivityIndicator(
                    radius: MediaQuery.of(context).size.width * 0.1),
              ),
            ),
          );
        }
        return Container(
          color: Colors.blue,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  IntrinsicWidth(
                    child: Container(
                      color: const Color.fromRGBO(105, 105, 105, 0.5),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(state.data!.id,
                              style:
                                  Theme.of(context).textTheme.headlineMedium),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  state.data!.player2?.name != _gameRoomBloc.username
                      ? (state.data!.player1!.name == _gameRoomBloc.username &&
                              state.data!.player2!.name != ""
                          ? Text("Možete da započnete igru",
                              style: Theme.of(context).textTheme.bodyMedium)
                          : Text("Pošaljite kod prijatelju da se pridruži igri",
                              style: Theme.of(context).textTheme.bodyMedium))
                      : Text("Čeka se vlasnik sobe da počne igru",
                          style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 20),
                  PlayerBoard(
                      player1: state.data!.player1!,
                      player2: state.data!.player2),
                  const SizedBox(height: 20),
                  state.data!.player2?.name != _gameRoomBloc.username
                      ? ButtonWithSize(
                          text: "Počni igru",
                          isEnabled: state.data!.player1 != null &&
                              state.data!.player1!.name != "" &&
                              state.data!.player2 != null &&
                              state.data!.player2!.name != "",
                          onPressed: () {
                            _gameRoomBloc.add(const InitStartGameEvent());
                          },
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
