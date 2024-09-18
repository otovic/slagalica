import 'package:flutter/material.dart';

class BuyCoinsOption extends StatelessWidget {
  BuyCoinsOption({
    super.key,
    required this.ammount,
    required this.price,
    required this.description,
    required this.selected,
    required this.onTap,
  });
  final String ammount;
  final String price;
  final String description;
  bool selected = false;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 223, 82, 106),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 5),
            ),
          ],
          border: selected
              ? Border.all(
                  color: Colors.white,
                  width: 2,
                )
              : Border.all(
                  color: Colors.transparent,
                  width: 2,
                ),
        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'images/coin.png',
                  width: 50,
                  height: 50,
                ),
                const SizedBox(width: 10),
                Text(
                  ammount == "Neograničeno"
                      ? "Neograničeno"
                      : "$ammount žetona",
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Text(
              "$price RSD",
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              softWrap: true,
              description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
