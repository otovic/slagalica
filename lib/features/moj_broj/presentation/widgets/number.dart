import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MojBrojNumberBox extends StatelessWidget {
  const MojBrojNumberBox({
    super.key,
    required this.number,
    this.width,
    this.onTap,
    required this.index,
    this.tapped = false,
  });
  final String number;
  final double? width;
  final int index;
  final bool tapped;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (tapped) return;
        if (onTap != null) {
          onTap!(index);
        }
      },
      child: Container(
          width:
              width != null ? MediaQuery.of(context).size.width * width! : null,
          height:
              width != null ? MediaQuery.of(context).size.width * width! : null,
          color: tapped ? Colors.grey : Colors.grey.shade900,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          )),
    );
  }
}
