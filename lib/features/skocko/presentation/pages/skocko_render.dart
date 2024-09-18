import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slagalica/core/resources/combination.dart';
import 'package:slagalica/features/skocko/presentation/bloc/skocko_bloc.dart';
import 'package:slagalica/features/skocko/presentation/widgets/combination_stripe.dart';
import 'package:slagalica/features/skocko/presentation/widgets/signs.dart';
import 'package:slagalica/shared/widgets/button_with_size.dart';

class SkockoRender extends StatelessWidget {
  SkockoRender({super.key, required this.bloc});
  SkockoBloc bloc;

  getText(SkockoInitialized state) {
    if (state.skocko.turn == state.playerIndex) {
      if (state.combinationIndex == 6 &&
          !state.skocko.playerGuesses[5].contains(0)) {
        return "Pogodili ste tačnu kombinaciju";
      } else if (state.combinationIndex == 6 &&
          state.skocko.oponnentGuess.isNotEmpty &&
          !state.skocko.oponnentGuess.contains(0)) {
        return "Protivnik je pronašao tačnu kombinaciju";
      } else if (state.combinationIndex < 6) {
        return "Pronađite tačnu kombinaciju";
      } else {
        return "Protivnik traži kombinaciju";
      }
    } else {
      if (state.combinationIndex == 6 &&
          !state.skocko.playerGuesses[5].contains(0)) {
        return "Protivnik je osvojio poene";
      } else if (state.combinationIndex == 6 &&
          state.skocko.oponnentGuess.isNotEmpty &&
          !state.skocko.oponnentGuess.contains(0)) {
        return "Osvojili ste poene";
      } else if (state.combinationIndex < 6) {
        return "Protivnik traži kombinaciju";
      } else {
        return "Pronađite tačnu kombinaciju";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Container(
        child: Center(
          child: BlocBuilder<SkockoBloc, SkockoState>(
            bloc: bloc,
            builder: (_, state) {
              if (state is SkockoUninitialized) {
                return const CupertinoActivityIndicator();
              } else if (state is SkockoInitialized) {
                if (state.skocko.turn == state.playerIndex &&
                    state.skocko.correct.isNotEmpty) {
                  if (state.skocko.over) {
                    bloc.add(const SkockoSubmitOverEvent());
                    return _buildRoundOver(state, context);
                  } else if (state.oponentTurn) {
                    bloc.add(const SkockoOponnentTurnEvent());
                    return _buildObserveSelectCombinations(state, context);
                  } else {
                    bloc.add(const SkockoStartTimerEvent());
                    return _buildSelectCombinations(state, context);
                  }
                } else if (state.skocko.turn != state.playerIndex &&
                    state.skocko.correct.isNotEmpty) {
                  if (state.skocko.over) {
                    bloc.add(const SkockoSubmitOverEvent());
                    return _buildRoundOver(state, context);
                  } else if (state.oponentTurn) {
                    bloc.add(const SkockoOponnentTurnEvent());
                    return _buildOponentTurn(state, context);
                  } else {
                    bloc.add(const SkockoStartTimerEvent());
                    return _buildObserveSelectCombinations(state, context);
                  }
                } else {
                  return const CupertinoActivityIndicator();
                }
              } else {
                return const Text("Error");
              }
            },
          ),
        ),
      ),
    );
  }

  _buildSelectCombinations(SkockoInitialized state, BuildContext context) {
    print("Select combinations");
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          getText(state),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.45,
              child: Column(
                children: state.combinations.asMap().entries.map((entry) {
                  int index = entry.key;
                  List<int> element = entry.value;

                  return Column(
                    children: [
                      CombinationStripe(
                        combination: index + 0 == state.combinationIndex
                            ? state.combination
                            : element,
                        index: index,
                        currentCombinationIndex: state.combinationIndex,
                        bloc: bloc,
                        color: Colors.white70,
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(width: 5),
            Container(
              width: MediaQuery.of(context).size.width * 0.45,
              child: Column(
                children: state.guesses.map((entry) {
                  return Column(
                    children: [
                      CombinationStripe(
                        guesses: entry,
                        bloc: bloc,
                        color: Colors.white54,
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.45,
              child: Column(
                children: [
                  CombinationStripe(
                      combination: state.oponnentCombinationLocal,
                      index: 7,
                      currentCombinationIndex: state.combinationIndex,
                      bloc: bloc,
                      color: Colors.white70),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            const SizedBox(width: 5),
            Container(
              width: MediaQuery.of(context).size.width * 0.45,
              child: Column(
                children: [
                  CombinationStripe(
                      guesses: state.oponnentGuess,
                      bloc: bloc,
                      color: Colors.white54),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SkockoSigns(
          color: Colors.white70,
          bloc: bloc,
        ),
        const SizedBox(height: 20),
        ButtonWithSize(
            text: "Potvrdi",
            isEnabled: state.combination.contains(0) ? false : true,
            onPressed: () {
              bloc.add(const SkockoSubmitCombinationEvent());
            }),
      ],
    );
  }

  _buildOponentTurn(SkockoInitialized state, BuildContext context) {
    print("Select combinations");
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          getText(state),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.45,
              child: Column(
                children: state.combinations.asMap().entries.map((entry) {
                  int index = entry.key;
                  List<int> element = entry.value;

                  return Column(
                    children: [
                      CombinationStripe(
                        combination: index + 0 == state.combinationIndex
                            ? state.combination
                            : element,
                        index: index,
                        currentCombinationIndex: state.combinationIndex,
                        bloc: bloc,
                        color: Colors.white70,
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(width: 5),
            Container(
              width: MediaQuery.of(context).size.width * 0.45,
              child: Column(
                children: state.guesses.map((entry) {
                  return Column(
                    children: [
                      CombinationStripe(
                        guesses: entry,
                        bloc: bloc,
                        color: Colors.white54,
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.45,
              child: Column(
                children: [
                  CombinationStripe(
                      combination: state.oponnentCombinationLocal,
                      index: 7,
                      currentCombinationIndex: state.combinationIndex,
                      bloc: bloc,
                      color: Colors.white70),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            const SizedBox(width: 5),
            Container(
              width: MediaQuery.of(context).size.width * 0.45,
              child: Column(
                children: [
                  CombinationStripe(
                      combination: state.oponnentGuess,
                      bloc: bloc,
                      color: Colors.white54),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SkockoSigns(
          color: Colors.white70,
          bloc: bloc,
        ),
        const SizedBox(height: 20),
        ButtonWithSize(
            text: "Potvrdi",
            isEnabled:
                state.oponnentCombinationLocal.contains(0) ? false : true,
            onPressed: () {
              bloc.add(const SkockoSubmitOponnentCombinationEvent());
            }),
      ],
    );
  }

  _buildObserveSelectCombinations(
    SkockoInitialized state,
    BuildContext context,
  ) {
    print("Observe select combinations");
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          getText(state),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.45,
              child: Column(
                children: state.combinations.asMap().entries.map((entry) {
                  int index = entry.key;
                  List<int> element = entry.value;

                  return Column(
                    children: [
                      CombinationStripe(
                        combination: element,
                        index: index,
                        currentCombinationIndex: state.combinationIndex,
                        bloc: bloc,
                        color: Colors.white70,
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(width: 5),
            Container(
              width: MediaQuery.of(context).size.width * 0.45,
              child: Column(
                children: state.guesses.map((entry) {
                  return Column(
                    children: [
                      CombinationStripe(
                        guesses: entry,
                        bloc: bloc,
                        color: Colors.white54,
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.45,
              child: Column(
                children: [
                  CombinationStripe(
                      combination: state.skocko.oponnentCombination,
                      index: 7,
                      currentCombinationIndex: state.combinationIndex,
                      bloc: bloc,
                      color: Colors.white70),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            const SizedBox(width: 5),
            Container(
              width: MediaQuery.of(context).size.width * 0.45,
              child: Column(
                children: [
                  CombinationStripe(
                      guesses: state.skocko.oponnentGuess,
                      bloc: bloc,
                      color: Colors.white54),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SkockoSigns(
          color: Colors.white70,
          bloc: bloc,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  _buildRoundOver(SkockoInitialized state, BuildContext context) {
    print("Observe select combinations");
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          getText(state),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.45,
              child: Column(
                children: state.combinations.asMap().entries.map((entry) {
                  int index = entry.key;
                  List<int> element = entry.value;

                  return Column(
                    children: [
                      CombinationStripe(
                        combination: element,
                        index: index,
                        currentCombinationIndex: state.combinationIndex,
                        bloc: bloc,
                        color: Colors.white70,
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(width: 5),
            Container(
              width: MediaQuery.of(context).size.width * 0.45,
              child: Column(
                children: state.guesses.map((entry) {
                  return Column(
                    children: [
                      CombinationStripe(
                        guesses: entry,
                        bloc: bloc,
                        color: Colors.white54,
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.45,
              child: Column(
                children: [
                  CombinationStripe(
                      combination: state.skocko.oponnentCombination,
                      index: 7,
                      currentCombinationIndex: state.combinationIndex,
                      bloc: bloc,
                      color: Colors.white70),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            const SizedBox(width: 5),
            Container(
              width: MediaQuery.of(context).size.width * 0.45,
              child: Column(
                children: [
                  CombinationStripe(
                      guesses: state.skocko.oponnentGuess,
                      bloc: bloc,
                      color: Colors.white54),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          width: MediaQuery.of(context).size.width * 0.45,
          child: Column(
            children: [
              const Text(
                "Tačna kombinacija",
                textAlign: TextAlign.center,
              ),
              CombinationStripe(
                combination: state.skocko.correct,
                bloc: bloc,
                color: Colors.white54,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SkockoSigns(
          color: Colors.white70,
          bloc: bloc,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
