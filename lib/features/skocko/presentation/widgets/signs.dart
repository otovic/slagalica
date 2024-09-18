import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:slagalica/features/skocko/presentation/bloc/skocko_bloc.dart';

class SkockoSigns extends StatelessWidget {
  const SkockoSigns({
    super.key,
    required this.color,
    required this.bloc,
  });

  final Color color;
  final SkockoBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            color: color,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: InkWell(
                onTap: () {
                  bloc.add(const SkockoAddSignEvent(1));
                },
                child: Image.asset(
                  "images/ladybug.png",
                  width: MediaQuery.of(context).size.width * 0.10,
                  height: MediaQuery.of(context).size.width * 0.10,
                ),
              ),
            ),
          ),
          Container(
            color: color,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: InkWell(
                onTap: () {
                  bloc.add(const SkockoAddSignEvent(2));
                },
                child: Image.asset(
                  "images/clubs.png",
                  width: MediaQuery.of(context).size.width * 0.10,
                  height: MediaQuery.of(context).size.width * 0.10,
                ),
              ),
            ),
          ),
          Container(
            color: color,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: InkWell(
                onTap: () {
                  bloc.add(const SkockoAddSignEvent(3));
                },
                child: Image.asset(
                  "images/spades.png",
                  width: MediaQuery.of(context).size.width * 0.10,
                  height: MediaQuery.of(context).size.width * 0.10,
                ),
              ),
            ),
          ),
          Container(
            color: color,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: InkWell(
                onTap: () {
                  bloc.add(const SkockoAddSignEvent(4));
                },
                child: Image.asset(
                  "images/hearts.png",
                  width: MediaQuery.of(context).size.width * 0.10,
                  height: MediaQuery.of(context).size.width * 0.10,
                ),
              ),
            ),
          ),
          Container(
            color: color,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: InkWell(
                onTap: () {
                  bloc.add(const SkockoAddSignEvent(5));
                },
                child: Image.asset(
                  "images/diamonds.png",
                  width: MediaQuery.of(context).size.width * 0.10,
                  height: MediaQuery.of(context).size.width * 0.10,
                ),
              ),
            ),
          ),
          Container(
            color: color,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: InkWell(
                onTap: () {
                  bloc.add(const SkockoAddSignEvent(6));
                },
                child: Image.asset(
                  "images/star.png",
                  width: MediaQuery.of(context).size.width * 0.10,
                  height: MediaQuery.of(context).size.width * 0.10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
