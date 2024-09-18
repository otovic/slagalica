import 'package:flutter/material.dart';
import 'package:slagalica/features/app_state_init/data/models/player_model.dart';
import 'package:slagalica/shared/widgets/player_board_card.dart';

class PlayerBoard extends StatelessWidget {
  const PlayerBoard({
    super.key,
    required this.player1,
    this.player2,
  });
  final PlayerModel player1;
  final PlayerModel? player2;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              PlayerBoardCard(index: 1, player: player1),
              PlayerBoardCard(index: 2, player: player2),
            ],
          ),
        ),
      ),
    );
  }
}
