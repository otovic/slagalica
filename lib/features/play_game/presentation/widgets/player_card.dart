import 'package:flutter/material.dart';
import 'package:slagalica/features/app_state_init/data/models/player_model.dart';
import 'package:slagalica/shared/widgets/circular_image.dart';

class PlayerCard extends StatelessWidget {
  PlayerCard(
      {super.key,
      required this.player,
      required this.index,
      required this.ready});
  PlayerModel player;
  int index = 0;
  bool ready = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      width: MediaQuery.of(context).size.width * 0.38,
      height: MediaQuery.of(context).size.height * 0.1,
      decoration: BoxDecoration(
        border: Border.all(
            color: index == 1
                ? Colors.blueAccent.shade700
                : Colors.redAccent.shade700,
            width: 3),
      ),
      child: ready == false
          ? _buildPlayerOffline(context)
          : (index == 1
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildImage(context),
                    _buildBody(context),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildBody(context),
                    _buildImage(context),
                  ],
                )),
    );
  }

  _buildPlayerOffline(BuildContext context) {
    return Icon(
      Icons.wifi_off,
      color: Colors.white,
      size: MediaQuery.of(context).size.height * 0.06,
    );
  }

  _buildImage(BuildContext context) {
    return CircularImage(
      image: player.image,
      size: MediaQuery.of(context).size.height * 0.06,
    );
  }

  _buildBody(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              player.name,
              textAlign: TextAlign.start,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            '${player.points}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
