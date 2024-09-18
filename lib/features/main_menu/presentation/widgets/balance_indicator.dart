import 'package:flutter/material.dart';

class BalanceIndicator extends StatelessWidget {
  BalanceIndicator({
    super.key,
    this.balance,
    this.balanceText,
    required this.image,
  });
  late final int? balance;
  late final String? balanceText;
  late final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(image, width: 40, height: 40),
          const SizedBox(width: 10),
          Text(
            balance != null ? balance.toString() : balanceText!,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
