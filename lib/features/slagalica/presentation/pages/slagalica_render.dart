import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slagalica/features/app_state_init/data/models/game_room_model.dart';
import 'package:slagalica/features/slagalica/presentation/bloc/slagalica_bloc.dart';
import 'package:slagalica/features/slagalica/presentation/widgets/letter.dart';
import 'package:slagalica/features/slagalica/presentation/widgets/slagalica_input.dart';
import 'package:slagalica/main.dart';
import 'package:slagalica/shared/widgets/button_with_size.dart';
import 'package:slagalica/shared/widgets/form_input.dart';

class SlagalicaRender extends StatelessWidget {
  SlagalicaRender({super.key, required this.bloc});
  SlagalicaBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: BlocBuilder<SlagalicaBloc, SlagalicaBlocState>(
            bloc: bloc,
            builder: (_, state) {
              if (state is SlagalicaBlocInitial) {
                return const CupertinoActivityIndicator();
              } else if (state is SlagalicaInitedState) {
                print(state.toString());
                if (state.letters.isEmpty) {
                  return _buildSelectLetters(state);
                } else if (state.word.isEmpty) {
                  return _buildLettersSelected(state, context);
                } else if (state.word.isNotEmpty &&
                    state.opponentWord.isEmpty) {
                  return _buildWaitingForOponent(state, context);
                } else if (state.word.isNotEmpty &&
                    state.opponentWord.isNotEmpty) {
                  return _buildAwardPoints(state, context);
                } else {
                  return const SizedBox();
                }
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }

  _buildAwardPoints(SlagalicaInitedState state, BuildContext context) {
    print("AWARD POINTS STATE");
    bloc.add(const SlagalicaAwardPointsEvent());

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          child: Text(
            "Nađite najdužu reč od ponudjenih slova",
            textAlign: TextAlign.center,
          ),
          width: MediaQuery.of(context).size.shortestSide * 0.9,
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 150,
          child: GridView.count(
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            crossAxisCount: 6,
            children: [
              SlagalicaLetterBox(
                letter: state.letters[0],
                index: 0,
                tapped: state.tapped[0] == 1,
                onTap: (letter, index) {},
              ),
              SlagalicaLetterBox(
                letter: state.letters[1],
                index: 1,
                tapped: state.tapped[1] == 1,
                onTap: (letter, index) {},
              ),
              SlagalicaLetterBox(
                letter: state.letters[2],
                index: 2,
                tapped: state.tapped[2] == 1,
                onTap: (letter, index) {},
              ),
              SlagalicaLetterBox(
                letter: state.letters[3],
                index: 3,
                tapped: state.tapped[3] == 1,
                onTap: (letter, index) {},
              ),
              SlagalicaLetterBox(
                letter: state.letters[4],
                index: 4,
                tapped: state.tapped[4] == 1,
                onTap: (letter, index) {},
              ),
              SlagalicaLetterBox(
                letter: state.letters[5],
                index: 5,
                tapped: state.tapped[5] == 1,
                onTap: (letter, index) {},
              ),
              SlagalicaLetterBox(
                letter: state.letters[6],
                index: 6,
                tapped: state.tapped[6] == 1,
                onTap: (letter, index) {},
              ),
              SlagalicaLetterBox(
                letter: state.letters[7],
                index: 7,
                tapped: state.tapped[7] == 1,
                onTap: (letter, index) {},
              ),
              SlagalicaLetterBox(
                letter: state.letters[8],
                index: 8,
                tapped: state.tapped[8] == 1,
                onTap: (letter, index) {},
              ),
              SlagalicaLetterBox(
                letter: state.letters[9],
                index: 9,
                tapped: state.tapped[9] == 1,
                onTap: (letter, index) {},
              ),
              SlagalicaLetterBox(
                letter: state.letters[10],
                index: 10,
                tapped: state.tapped[10] == 1,
                onTap: (letter, index) {},
              ),
              SlagalicaLetterBox(
                letter: state.letters[11],
                index: 11,
                tapped: state.tapped[11] == 1,
                onTap: (letter, index) {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SlagalicaInput(
          word: state.word,
          index: state.playerIndex,
          owner: true,
          comitted: true,
          winner: state.winner,
        ),
        const SizedBox(height: 20),
        SlagalicaInput(
          word: state.opponentWord,
          index: state.playerIndex == 1 ? 2 : 1,
          owner: false,
          comitted: false,
          winner: state.winner,
        ),
        const SizedBox(height: 20),
        state.winner == 0
            ? Text("Nema poena za ovu igru")
            : (state.winner == 1 && state.playerIndex == 1
                ? Text("Osvojili ste poene")
                : Text("Protivnik je osvojio poene")),
      ],
    );
  }

  _buildSelectLetters(SlagalicaInitedState state) {
    print("Select letters STATE");
    bloc.add(const SlagalicaLetterSelectEvent());

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        state.playerIndex == state.turn
            ? const Text("Kliknite na dugme da izaberete slova")
            : const Text("Protivnik bira slova"),
        const SizedBox(height: 20),
        SizedBox(
          height: 150,
          child: GridView.count(
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            crossAxisCount: 6,
            children: state.generatedLetters.map((letter) {
              return SlagalicaLetterBox(
                letter: letter,
                index: state.letters.indexOf(letter),
                tapped: false,
                onTap: (letter, index) {},
              );
            }).toList(),
          ),
        ),
        state.playerIndex == state.turn
            ? ButtonWithSize(
                text: "Izaberi slova",
                onPressed: () {
                  bloc.add(const SlagalicaStopLettersEvent());
                })
            : const SizedBox()
      ],
    );
  }

  _buildLettersSelected(SlagalicaInitedState state, BuildContext context) {
    print("Letters selected STATE");
    bloc.add(const SlagalicaLettersSelectedEvent());

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          child: Text(
            "Nađite najdužu reč od ponudjenih slova",
            textAlign: TextAlign.center,
          ),
          width: MediaQuery.of(context).size.shortestSide * 0.9,
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 150,
          child: GridView.count(
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            crossAxisCount: 6,
            children: state.letters.asMap().entries.map((entry) {
              int index = entry.key;
              String letter = entry.value;

              return SlagalicaLetterBox(
                letter: letter,
                index: index,
                tapped: state.tapped[index] == 1,
                onTap: (letter, index) {
                  bloc.add(SlagalicaAddLetterEvent(letter, index));
                },
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),
        SlagalicaInput(
          word: state.wordLocal,
          index: state.playerIndex,
          owner: true,
          comitted: state.playerIndex == 1
              ? state.word.isEmpty
              : state.opponentWord.isEmpty,
          onDelete: () {
            bloc.add(const SlagalicaRemoveLetterEvent());
          },
          wordStatus: state.wordExistLocal,
        ),
        const SizedBox(height: 20),
        SlagalicaInput(
          word: "",
          index: state.playerIndex == 1 ? 2 : 1,
          owner: false,
          comitted: false,
        ),
        const SizedBox(height: 20),
        ButtonWithSize(
          text: "Potvrdi",
          isLoading: state.progress,
          onPressed: () {
            bloc.add(const SlagalicaCommitWordEvent());
          },
        )
      ],
    );
  }

  _buildWaitingForOponent(SlagalicaInitedState state, BuildContext context) {
    print("Waiting for oponent STATE");
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          child: Text(
            "Nađite najdužu reč od ponudjenih slova",
            textAlign: TextAlign.center,
          ),
          width: MediaQuery.of(context).size.shortestSide * 0.9,
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 150,
          child: GridView.count(
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            crossAxisCount: 6,
            children: state.letters.asMap().entries.map((entry) {
              int index = entry.key;
              String letter = entry.value;
              return SlagalicaLetterBox(
                letter: letter,
                index: index,
                tapped: state.tapped[index] == 1,
                onTap: (letter, index) {
                  bloc.add(SlagalicaAddLetterEvent(letter, index));
                },
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),
        SlagalicaInput(
          word: state.word,
          index: state.playerIndex,
          owner: false,
          comitted: true,
          onDelete: null,
          wordStatus: state.word != "NEMA REČ" ? 2 : 3,
        ),
        const SizedBox(height: 20),
        SlagalicaInput(
          word: "",
          index: state.playerIndex == 1 ? 2 : 1,
          owner: false,
          comitted: false,
          onDelete: null,
        ),
        const SizedBox(height: 20),
        const Text("Čeka se protivnik"),
        const SizedBox(height: 20),
        const CupertinoActivityIndicator(),
      ],
    );
  }
}
