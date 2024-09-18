import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SlagalicaLetterBox extends StatelessWidget {
  const SlagalicaLetterBox(
      {super.key,
      required this.letter,
      this.onTap,
      required this.index,
      this.tapped = false});
  final String letter;
  final int index;
  final bool tapped;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (tapped) return;
        if (onTap != null) {
          onTap!(letter, index);
        }
      },
      child: Container(
          color: tapped ? Colors.grey : Colors.grey.shade900,
          child: Center(
            child: Text(
              letter,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          )),
    );
  }
}
