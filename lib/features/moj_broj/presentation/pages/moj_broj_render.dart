import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slagalica/features/moj_broj/presentation/bloc/moj_broj_bloc.dart';
import 'package:slagalica/features/moj_broj/presentation/bloc/moj_broj_event.dart';
import 'package:slagalica/features/moj_broj/presentation/bloc/moj_broj_state.dart';
import 'package:slagalica/features/moj_broj/presentation/widgets/number.dart';
import 'package:slagalica/features/moj_broj/presentation/widgets/user_number_input.dart';
import 'package:slagalica/shared/widgets/button_with_size.dart';

class MojBrojRender extends StatelessWidget {
  MojBrojRender({super.key, required this.bloc});
  MojBrojBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: BlocBuilder<MojBrojBloc, MojBrojState>(
            bloc: bloc,
            builder: (_, state) {
              if (state is MojBrojInitial) {
                return const CupertinoActivityIndicator();
              } else if (state is MojBrojInitedState) {
                if (state.mojBroj.smallNumbers.isEmpty) {
                  return _buildSelectNumbers(state, context);
                } else if ((state.playerIndex == 1 &&
                    state.mojBroj.playerOneExpression == "")) {
                  return _buildNumbersSelected(state, context);
                } else if (state.playerIndex == 2 &&
                    state.mojBroj.playerTwoExpression == "") {
                  return _buildNumbersSelected(state, context);
                } else if (state.playerIndex == 1 &&
                    state.mojBroj.playerOneExpression != "" &&
                    state.mojBroj.playerTwoExpression == "") {
                  return _buildCalculationSubmited(state, context);
                } else if (state.playerIndex == 2 &&
                    state.mojBroj.playerOneExpression == "" &&
                    state.mojBroj.playerTwoExpression != "") {
                  return _buildCalculationSubmited(state, context);
                } else if (state.mojBroj.playerOneExpressionResult != "" &&
                    state.mojBroj.playerTwoExpressionResult != "") {
                  return _buildAwardPoints(state, context);
                } else {
                  return _buildAwardPoints(state, context);
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

  _buildSelectNumbers(MojBrojInitedState state, BuildContext context) {
    bloc.add(const MojBrojStartNumberShuffle());
    List<String> numbers = [
      state.localSmallNumbers[0].toString(),
      state.localSmallNumbers[1].toString(),
      state.localSmallNumbers[2].toString(),
      state.localSmallNumbers[3].toString(),
      state.localMiddleNumber.toString(),
      state.localBigNumber.toString(),
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        state.mojBroj.turn == state.playerIndex
            ? const Text("Kliknite na dugme da zaustavite broj",
                textAlign: TextAlign.center)
            : const Text("Čeka se protivnik da izabere brojeve",
                textAlign: TextAlign.center),
        const SizedBox(height: 20),
        MojBrojNumberBox(
          number: state.localGoal.toString(),
          index: state.playerIndex,
        ),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 6,
          shrinkWrap: true,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          children: numbers.map((number) {
            return MojBrojNumberBox(
              number: number,
              index: state.playerIndex,
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        state.mojBroj.turn == state.playerIndex
            ? ButtonWithSize(
                text: "Stopiraj brojeve",
                onPressed: () {
                  bloc.add(const MojBrojChooseNumbersEvent());
                },
              )
            : const SizedBox(),
      ],
    );
  }

  _buildNumbersSelected(MojBrojInitedState state, BuildContext context) {
    print("Numbers selected");
    bloc.add(const MojBrojCalculateEvent());

    List<String> numbers = [
      state.mojBroj.smallNumbers[0].toString(),
      state.mojBroj.smallNumbers[1].toString(),
      state.mojBroj.smallNumbers[2].toString(),
      state.mojBroj.smallNumbers[3].toString(),
      state.mojBroj.middleNumber.toString(),
      state.mojBroj.bigNumber.toString(),
    ];

    List<String> operations = ["+", "-", "*", "/", "(", ")"];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Dođite do broja ${state.mojBroj.goal} koristeći ponuđene brojeve",
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        MojBrojNumberBox(
          number: state.mojBroj.goal.toString(),
          index: state.playerIndex,
        ),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 6,
          shrinkWrap: true,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          children: numbers.asMap().entries.map((entry) {
            var number = entry.value;
            var index = entry.key + 1;

            return MojBrojNumberBox(
              number: number,
              tapped: state.clickedNumbers.contains(index),
              index: index,
              onTap: (index) {
                bloc.add(
                  MojBrojAddCalculationEvent(expression: number, index: index),
                );
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        GridView.count(
          crossAxisCount: 6,
          shrinkWrap: true,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          children: operations.asMap().entries.map((entry) {
            var operation = entry.value;
            var index = entry.key;

            return MojBrojNumberBox(
              number: operation,
              index: index,
              onTap: (index) {
                bloc.add(
                  MojBrojAddCalculationEvent(
                    expression: operation,
                    index: 0,
                  ),
                );
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        MojBrojExpressionInput(
          placeholder: "Vaša računica",
          index: state.playerIndex,
          owner: true,
          onDelete: () {
            bloc.add(const MojBrojRemoveCalculationEvent());
          },
          comitted: state.playerIndex == 1
              ? state.mojBroj.playerOneExpression != ""
              : state.mojBroj.playerTwoExpression != "",
          expression: state.localExpression,
        ),
        const SizedBox(height: 10),
        MojBrojExpressionInput(
          placeholder: "Računica protivnika",
          index: state.playerIndex == 1 ? 2 : 1,
          owner: false,
          comitted: false,
        ),
        const SizedBox(height: 20),
        ButtonWithSize(
          text: "Potvrdi računicu",
          onPressed: () {
            bloc.add(const MojBrojSubmitExpressionEvent());
          },
        ),
      ],
    );
  }

  _buildCalculationSubmited(MojBrojInitedState state, BuildContext context) {
    print("Calculation submited");
    List<String> numbers = [
      state.mojBroj.smallNumbers[0].toString(),
      state.mojBroj.smallNumbers[1].toString(),
      state.mojBroj.smallNumbers[2].toString(),
      state.mojBroj.smallNumbers[3].toString(),
      state.mojBroj.middleNumber.toString(),
      state.mojBroj.bigNumber.toString(),
    ];

    List<String> operations = ["+", "-", "*", "/", "(", ")"];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Dođite do broja ${state.mojBroj.goal} koristeći ponuđene brojeve",
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        MojBrojNumberBox(
          number: state.mojBroj.goal.toString(),
          index: state.playerIndex,
        ),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 6,
          shrinkWrap: true,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          children: numbers.asMap().entries.map((entry) {
            var number = entry.value;
            var index = entry.key + 1;

            return MojBrojNumberBox(
              number: number,
              tapped: state.clickedNumbers.contains(index),
              index: index,
              onTap: (index) {},
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        GridView.count(
          crossAxisCount: 6,
          shrinkWrap: true,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          children: operations.asMap().entries.map((entry) {
            var operation = entry.value;
            var index = entry.key;

            return MojBrojNumberBox(
              number: operation,
              index: index,
              onTap: (index) {},
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        MojBrojExpressionInput(
          placeholder: "Vaša računica",
          index: state.playerIndex,
          owner: true,
          onDelete: () {},
          comitted: state.playerIndex == 1
              ? state.mojBroj.playerOneExpression != ""
              : state.mojBroj.playerTwoExpression != "",
          expression: state.localExpression + "=${state.result}",
        ),
        const SizedBox(height: 10),
        MojBrojExpressionInput(
          placeholder: "Računica protivnika",
          index: state.playerIndex == 1 ? 2 : 1,
          owner: false,
          comitted: false,
        ),
        const SizedBox(height: 20),
        const Text("Čeka se protivnik"),
        const SizedBox(height: 20),
        const CupertinoActivityIndicator(),
      ],
    );
  }

  _buildAwardPoints(MojBrojInitedState state, BuildContext context) {
    bloc.add(const MojBrojEndGameEvent());

    List<String> numbers = [
      state.mojBroj.smallNumbers[0].toString(),
      state.mojBroj.smallNumbers[1].toString(),
      state.mojBroj.smallNumbers[2].toString(),
      state.mojBroj.smallNumbers[3].toString(),
      state.mojBroj.middleNumber.toString(),
      state.mojBroj.bigNumber.toString(),
    ];

    List<String> operations = ["+", "-", "*", "/", "(", ")"];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
            "Dođite do broja ${state.mojBroj.goal} koristeći ponuđene brojeve"),
        const SizedBox(height: 20),
        MojBrojNumberBox(
          number: state.mojBroj.goal.toString(),
          index: state.playerIndex,
        ),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 6,
          shrinkWrap: true,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          children: numbers.asMap().entries.map((entry) {
            var number = entry.value;
            var index = entry.key + 1;

            return MojBrojNumberBox(
              number: number,
              tapped: state.clickedNumbers.contains(index),
              index: index,
              onTap: (index) {},
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        GridView.count(
          crossAxisCount: 6,
          shrinkWrap: true,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          children: operations.asMap().entries.map((entry) {
            var operation = entry.value;
            var index = entry.key;

            return MojBrojNumberBox(
              number: operation,
              index: index,
              onTap: (index) {},
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        MojBrojExpressionInput(
            placeholder: "Vaša računica",
            index: state.playerIndex,
            owner: true,
            comitted: state.playerIndex == 1
                ? state.mojBroj.playerOneExpression != ""
                : state.mojBroj.playerTwoExpression != "",
            expression:
                bloc.getExpressionString(state.localExpression, state.result)),
        const SizedBox(height: 10),
        MojBrojExpressionInput(
          expression: bloc.getExpressionString(
              state.playerIndex == 1
                  ? state.mojBroj.playerTwoExpression
                  : state.mojBroj.playerOneExpression,
              state.playerIndex == 1
                  ? state.mojBroj.playerTwoExpressionResult
                  : state.mojBroj.playerOneExpressionResult),
          placeholder: "Računica protivnika",
          index: state.playerIndex == 1 ? 2 : 1,
          owner: false,
          comitted: false,
        ),
        const SizedBox(height: 20),
        state.winner == 0
            ? Text("Nema poena u ovoj igri")
            : (state.winner == state.playerIndex
                ? Text("Osvojili ste poene")
                : Text("Protivnik je osvojio poene")),
      ],
    );
  }
}
