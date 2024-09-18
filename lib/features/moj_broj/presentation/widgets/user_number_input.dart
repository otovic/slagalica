import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MojBrojExpressionInput extends StatelessWidget {
  MojBrojExpressionInput({
    super.key,
    required this.index,
    this.expression = "",
    this.onDelete,
    required this.owner,
    required this.comitted,
    this.winner = 0,
    this.placeholder = "",
  });
  int index = 0;
  String expression = "";
  String placeholder = "";
  final Function? onDelete;
  final bool owner;
  bool comitted = false;
  int winner = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      width: MediaQuery.of(context).size.width * 0.8,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(
            color: winner == index
                ? const Color.fromARGB(255, 44, 222, 165)
                : Colors.blueAccent.shade700,
            width: 3),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          expression.isEmpty
              ? Text(
                  placeholder,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                )
              : Expanded(
                  child: Text(
                    expression,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
          if (owner && onDelete != null)
            IconButton(
              onPressed: () {
                if (onDelete != null) {
                  onDelete!();
                }
              },
              icon: const Icon(Icons.delete),
            ),
        ],
      ),
    );
  }
}
