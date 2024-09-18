import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppStateLoading extends StatelessWidget {
  const AppStateLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CupertinoActivityIndicator(
          radius: 16,
        ),
        const SizedBox(height: 16.0),
        Text(
          'Učitavanje',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
