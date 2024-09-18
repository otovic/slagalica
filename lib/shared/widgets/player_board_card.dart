import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:slagalica/features/app_state_init/data/models/player_model.dart';
import 'package:slagalica/features/main_menu/presentation/widgets/balance_indicator.dart';
import 'package:slagalica/shared/widgets/circular_image.dart';

class PlayerBoardCard extends StatelessWidget {
  const PlayerBoardCard({
    super.key,
    required this.index,
    required this.player,
  });
  final int index;
  final PlayerModel? player;

  @override
  Widget build(BuildContext context) {
    return player != null && player!.name.isNotEmpty
        ? Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: index == 1
                    ? Colors.blueAccent.shade700
                    : Colors.redAccent.shade700,
                width: 4,
              ),
            ),
            width: MediaQuery.of(context).size.width * 0.35,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularImage(
                    image: player!.image,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    player!.name,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: BalanceIndicator(
                        image: "images/trophy.png", balance: player!.wins),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: BalanceIndicator(
                        image: "images/ranking.png", balance: player!.rank),
                  ),
                ],
              ),
            ),
          )
        : _buildEmpty(context);
  }

  _buildEmpty(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: index == 1
              ? Colors.blueAccent.shade700
              : Colors.redAccent.shade700,
          width: 4,
        ),
      ),
      width: MediaQuery.of(context).size.width * 0.35,
      height: MediaQuery.of(context).size.height * 0.5,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoActivityIndicator(),
            const SizedBox(height: 10),
            Text(
              'Čeka se igrač',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
