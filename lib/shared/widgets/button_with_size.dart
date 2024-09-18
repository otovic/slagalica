import 'package:flutter/material.dart';

class ButtonWithSize extends StatelessWidget {
  final String text;
  final Function onPressed;
  late final double? width;
  late final double? height;
  late final bool? isLoading;
  bool isEnabled = true;

  ButtonWithSize({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.isLoading = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * (width ?? 0.6),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(
            isEnabled ? Colors.white : Colors.grey,
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        onPressed: isEnabled ? () => onPressed() : null,
        child: isLoading != null && isLoading!
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              )
            : Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.black),
              ),
      ),
    );
  }
}
