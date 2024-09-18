import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slagalica/dependency_injector.dart';
import 'package:slagalica/features/app_state_init/data/models/game_models/skocko_model.dart';
import 'package:slagalica/features/app_state_init/data/models/game_room_model.dart';
import 'package:slagalica/features/app_state_init/presentation/bloc/app_state_bloc.dart';
import 'package:slagalica/features/app_state_init/presentation/bloc/app_state_event.dart';
import 'package:slagalica/features/app_state_init/presentation/bloc/app_state_state.dart';
import 'package:slagalica/features/buy_coins/presentation/bloc/buy_coins_bloc.dart';
import 'package:slagalica/features/buy_coins/presentation/pages/buy_coins.dart';
import 'package:slagalica/features/game_room/presentation/bloc/game_room_bloc.dart';
import 'package:slagalica/features/game_room/presentation/pages/game_room_page.dart';
import 'package:slagalica/features/main_menu/presentation/widgets/balance_indicator.dart';
import 'package:slagalica/features/play_game/presentation/pages/play_game_page.dart';
import 'package:slagalica/shared/widgets/button_with_size.dart';
import 'package:slagalica/shared/widgets/circular_image.dart';
import 'package:slagalica/shared/widgets/form_input.dart';

class MainMenuPage extends StatelessWidget {
  MainMenuPage({super.key});
  late AppStateBloc appStateBloc;
  TextEditingController roomCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    appStateBloc = BlocProvider.of<AppStateBloc>(context);

    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(190),
      child: Container(
        color: Colors.blue,
        child: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.blue,
                  width: 0,
                ),
              ),
            ),
            child: BlocBuilder<AppStateBloc, AppStateState>(
              bloc: appStateBloc,
              builder: (_, state) {
                print(state);
                if (state is AppStateUninitialized) {
                  return const CupertinoActivityIndicator();
                } else if (state is AppStateInitializedUser) {
                  print(state.data!.userData!);
                  return Column(
                    children: [
                      Container(
                        height: 140,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              CircularImage(
                                image: state.data!.userData?.imageURL ?? "",
                              ),
                              const SizedBox(height: 10),
                              Text(
                                state.data!.userData!.username,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Tooltip(
                                message: "Broj žetona",
                                child: BalanceIndicator(
                                  balanceText:
                                      state.data!.userData!.unlimited != ''
                                          ? "∞"
                                          : state.data!.userData!.coins
                                              .toString(),
                                  image: "images/coin.png",
                                ),
                              ),
                              Tooltip(
                                message: "Ovo je vaš broj pobeda",
                                child: BalanceIndicator(
                                  balanceText:
                                      state.data!.userData!.wins.toString(),
                                  image: "images/trophy.png",
                                ),
                              ),
                              Tooltip(
                                message: "Ovo je vaša pozicija na rang listi",
                                child: BalanceIndicator(
                                  balanceText:
                                      state.data!.userData!.wins.toString(),
                                  image: "images/ranking.png",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  _buildBody(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ButtonWithSize(
                    text: "Igraj",
                    onPressed: () async {
                      // await FirebaseFirestore.instance
                      //     .collection('rooms')
                      //     .doc("UJPTVY2")
                      //     .update({
                      //   "mojBroj.smallNumbers": [],
                      //   "mojBroj.playerOneExpression": "",
                      //   "mojBroj.playerTwoExpression": "",
                      //   "mojBroj.playerOneExpressionResult": "",
                      //   "mojBroj.playerExpressionTwoResult": "",
                      // });

                      await FirebaseFirestore.instance
                          .collection('rooms')
                          .doc("UJPTVY2")
                          .update({"skocko": SkockoModel.empty().toJson()});
                      var res = await FirebaseFirestore.instance
                          .collection("rooms")
                          .doc("UJPTVY2")
                          .get();
                      print(res);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PlayGamePage(
                            gameRoom: GameRoomModel.fromJson(
                                res.data() as Map<String, dynamic>),
                            username: "Cigara",
                          ),
                        ),
                      );
                    }),
                const SizedBox(height: 10),
                ButtonWithSize(text: "Rang lista", onPressed: () {}),
                const SizedBox(height: 10),
                ButtonWithSize(text: "Osvoji žetone", onPressed: () {}),
                const SizedBox(height: 10),
                ButtonWithSize(
                  text: "Kupi žetone",
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BuyCoins(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Text("Igraj sa prijateljima",
                    style: Theme.of(context).textTheme.bodyMedium!),
                const SizedBox(height: 10),
                BlocBuilder<AppStateBloc, AppStateState>(
                  bloc: appStateBloc,
                  builder: (_, state) {
                    if (state is AppStateCreatingRoom) {
                      return ButtonWithSize(
                        text: "Napravi sobu",
                        onPressed: () {},
                        isLoading: true,
                      );
                    }
                    if (state is AppStateCreateRoomError) {
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) {
                          appStateBloc.add(
                            ShowSnackBarEvent(
                              context: context,
                              message: state.message,
                            ),
                          );
                        },
                      );
                    }
                    if (state is AppStateRoomCreated) {
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => BlocProvider<GameRoomBloc>(
                                create: (_) => GameRoomBloc(
                                  appStateBloc,
                                  appStateBloc.state.data!.user!.displayName!,
                                  di(),
                                  context,
                                ),
                                child: GameRoomPage(
                                  gameRoom: state.gameRoom,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return ButtonWithSize(
                      text: "Napravi sobu",
                      onPressed: () {
                        appStateBloc.add(const AppStateCreateRoom());
                      },
                    );
                  },
                ),
                BlocBuilder<AppStateBloc, AppStateState>(
                  bloc: appStateBloc,
                  builder: (_, state) {
                    if (state is AppStateJoiningRoom) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ButtonWithSize(
                          text: "Pridruži se sobi",
                          onPressed: () {},
                          isLoading: true,
                        ),
                      );
                    }
                    if (state is AppStateRoomJoined) {
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => BlocProvider<GameRoomBloc>(
                                create: (_) => GameRoomBloc(
                                  appStateBloc,
                                  appStateBloc.state.data!.user!.displayName!,
                                  di(),
                                  context,
                                ),
                                child: GameRoomPage(
                                  gameRoom: state.gameRoom,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                    if (state is AppStateRoomJoinError) {
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) {
                          appStateBloc.add(
                            ShowSnackBarEvent(
                                context: context, message: state.message),
                          );
                        },
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ButtonWithSize(
                        text: "Pridruži se",
                        onPressed: () {
                          appStateBloc.add(
                            AppStateJoinRoomInit(
                              roomId: roomCodeController.text,
                              callback: () {
                                _showJoinRoomModal(context);
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Text("Ostalo", style: Theme.of(context).textTheme.bodyMedium!),
                const SizedBox(height: 10),
                ButtonWithSize(text: "Podešavanja", onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildBottomNavigationBar(BuildContext context) {
    return SizedBox(
      height: 50,
      child: BottomAppBar(
        color: Colors.blue,
        padding: const EdgeInsets.all(0),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.blue,
                width: 0,
              ),
            ),
          ),
          child: Center(
            child: Text(
              "SLAGALICA",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(fontFamily: "Honey"),
            ),
          ),
        ),
      ),
    );
  }

  _showJoinRoomModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              color: Colors.blue,
              height: MediaQuery.of(context).size.height * 0.2,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FormInput(
                      hintText: "Unesite kod sobe",
                      onChanged: (value) {
                        roomCodeController.text = value;
                      },
                    ),
                    BlocBuilder<AppStateBloc, AppStateState>(
                      bloc: appStateBloc,
                      builder: (_, state) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ButtonWithSize(
                            text: "Pridruži se",
                            onPressed: () {
                              Navigator.pop(context);
                              appStateBloc.add(
                                AppStateJoinRoom(
                                    roomId: roomCodeController.text),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
