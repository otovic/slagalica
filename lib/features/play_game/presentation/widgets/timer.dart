import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Timer extends StatefulWidget {
  Timer({super.key, required this.time, required this.turn});
  int time;
  int turn;

  @override
  State<Timer> createState() => _TimerState();
}

class _TimerState extends State<Timer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            Icons.arrow_back,
            color: widget.turn == 1 ? Colors.white : Colors.grey,
            size: 15,
          ),
          Center(
            child: Text(
              widget.time.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
          Icon(
            Icons.arrow_forward,
            color: widget.turn == 2 ? Colors.white : Colors.grey,
            size: 15,
          ),
        ],
      ),
    );
  }
}
