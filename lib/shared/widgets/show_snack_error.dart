import 'package:flutter/material.dart';

void showSnackError(BuildContext context, String error,
    {Duration duration = const Duration(seconds: 3), bool isWarning = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: duration,
      content: Text(
        error,
        style: Theme.of(context)
            .textTheme
            .bodySmall!
            .copyWith(color: Colors.white),
      ),
      backgroundColor: isWarning ? Colors.red : Colors.green,
    ),
  );
}
