import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:slagalica/core/resources/combination.dart';
import 'package:slagalica/features/skocko/presentation/bloc/skocko_bloc.dart';

class CombinationStripe extends StatelessWidget {
  const CombinationStripe({
    super.key,
    this.combination,
    this.guesses,
    this.index,
    this.currentCombinationIndex,
    required this.bloc,
    required this.color,
  });

  final List<int>? combination;
  final List<int>? guesses;
  final int? index;
  final int? currentCombinationIndex;
  final SkockoBloc bloc;
  final Color color;

  _getImage(int index) {
    if (index == 1) {
      return "images/ladybug.png";
    } else if (index == 2) {
      return "images/clubs.png";
    } else if (index == 3) {
      return "images/spades.png";
    } else if (index == 4) {
      return "images/hearts.png";
    } else if (index == 5) {
      return "images/diamonds.png";
    } else if (index == 6) {
      return "images/star.png";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return combination != null
        ? Container(
            color: Colors.black45,
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: combination!.toList().map((e) {
                  return InkWell(
                    onTap: () {
                      if (index != null) {
                        bloc.add(const SkockoRemoveSignEvent());
                      }
                    },
                    child: Container(
                      color: color,
                      width: MediaQuery.of(context).size.width * 0.10,
                      height: MediaQuery.of(context).size.width * 0.10,
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: e == 0
                            ? null
                            : Image.asset(
                                _getImage(e),
                              ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          )
        : Container(
            color: Colors.black45,
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: guesses!.map((e) {
                  return Container(
                    color: e == 1
                        ? Color.fromARGB(218, 224, 49, 37)
                        : e == 2
                            ? Color.fromARGB(204, 255, 233, 34)
                            : color,
                    width: MediaQuery.of(context).size.width * 0.10,
                    height: MediaQuery.of(context).size.width * 0.10,
                  );
                }).toList(),
              ),
            ),
          );
  }
}
