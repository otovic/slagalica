import 'package:flutter/material.dart';

class WrappedText extends StatelessWidget {
  final String text;
  final double? width;
  final TextAlign? textAlign;
  final TextStyle? textStyle;
  const WrappedText({
    super.key,
    required this.text,
    this.width,
    this.textAlign,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * (width ?? 0.6),
      child: Text(
        text,
        style: textStyle ?? Theme.of(context).textTheme.bodySmall!,
        textAlign: textAlign ?? TextAlign.center,
      ),
    );
  }
}
