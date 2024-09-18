import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slagalica/features/app_state_init/data/models/game_room_model.dart';
import 'package:slagalica/features/play_game/presentation/bloc/play_game_bloc.dart';
import 'package:slagalica/features/play_game/presentation/widgets/player_card.dart';
import 'package:slagalica/features/play_game/presentation/widgets/timer.dart';

class PlayGamePage extends StatelessWidget {
  PlayGamePage({super.key, required this.gameRoom, required this.username});
  final GameRoomModel gameRoom;
  final String username;
  late PlayGameBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = PlayGameBloc(gameRoom, username);
    return Scaffold(
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: SafeArea(
        child: SizedBox.expand(
          child: Container(
            color: Colors.blue,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: BlocBuilder<PlayGameBloc, PlayGameState>(
                    bloc: bloc,
                    buildWhen: (previous, current) {
                      if (current is PlayGameLoadedState &&
                          previous is PlayGameLoadedState) {
                        if (current.time != previous.time ||
                            current.gameRoom.player1!.ready !=
                                previous.gameRoom.player1!.ready ||
                            current.gameRoom.player2!.ready !=
                                previous.gameRoom.player2!.ready ||
                            current.gameRoom.player1!.points !=
                                previous.gameRoom.player1!.points ||
                            current.gameRoom.player2!.points !=
                                previous.gameRoom.player2!.points) {
                          return true;
                        } else {
                          return false;
                        }
                      } else {
                        return true;
                      }
                    },
                    builder: (_, state) {
                      if (state is PlayGameLoadingState) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is PlayGameLoadedState) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PlayerCard(
                              player: state.gameRoom.player1!,
                              index: 1,
                              ready: state.gameRoom.player1!.ready,
                            ),
                            Timer(
                              time: state.time ?? 0,
                              turn: state.turn ?? 1,
                            ),
                            PlayerCard(
                              player: state.gameRoom.player2!,
                              index: 2,
                              ready: state.gameRoom.player2!.ready,
                            ),
                          ],
                        );
                      } else {
                        return const Center(
                          child: Text("Error"),
                        );
                      }
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: BlocBuilder<PlayGameBloc, PlayGameState>(
                      bloc: bloc,
                      builder: (_, state) {
                        if (state is PlayGameLoadedState &&
                            state.currentGame != null) {
                          return state.currentGame!.render;
                        } else {
                          return const Center(
                            child: CupertinoActivityIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
