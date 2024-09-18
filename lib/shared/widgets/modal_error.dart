import 'package:flutter/material.dart';

void ShowModalError(BuildContext context, String error) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          color: Colors.red,
          child: Center(
            child: Text(
              error,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
      );
    },
  );
}
