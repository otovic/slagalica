import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SlagalicaInput extends StatelessWidget {
  SlagalicaInput(
      {super.key,
      required this.index,
      this.word = "",
      this.onDelete,
      required this.owner,
      required this.comitted,
      this.winner = 0,
      this.wordStatus = 0});
  int index = 0;
  String word = "SIGMAMEJLSKIBIDITOJLET";
  final Function? onDelete;
  final bool owner;
  bool comitted = false;
  int winner = 0;
  int wordStatus;

  getStatus() {
    if (owner) {
      if (wordStatus == 0) {
        return Container();
      } else if (wordStatus == 1) {
        return const CupertinoActivityIndicator();
      } else if (wordStatus == 2) {
        return const Icon(
          Icons.check,
          color: Colors.green,
        );
      } else {
        return const Icon(
          Icons.close,
          color: Colors.red,
        );
      }
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      width: MediaQuery.of(context).size.width * 0.8,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(
            color: winner == index
                ? Color.fromARGB(255, 44, 222, 165)
                : Colors.blueAccent.shade700,
            width: 3),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Row(
        children: [
          word == ""
              ? Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      owner ? "Vaša reč" : "Protivnikova reč",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              : Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      word == "mty" ? "NEMA REČ" : word,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
          getStatus(),
          owner && onDelete != null
              ? InkWell(
                  onTap: () => onDelete!(),
                  child: Icon(
                    Icons.delete,
                    color: Colors.blueAccent.shade700,
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
