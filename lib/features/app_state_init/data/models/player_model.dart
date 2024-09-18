import 'package:slagalica/features/app_state_init/domain/entities/player_entity.dart';

class PlayerModel extends PlayerEntity {
  final String id;
  final String name;
  final String image;
  final int wins;
  bool ready;
  final int rank;
  int points = 0;
  int oobIndex = 0;
  String event = "";

  PlayerModel({
    required this.id,
    required this.name,
    required this.image,
    required this.wins,
    this.ready = false,
    required this.rank,
    required this.points,
    this.oobIndex = 0,
    this.event = "",
  }) : super(
          id: id,
          name: name,
          image: image,
          wins: wins,
          ready: ready,
          rank: rank,
          points: points,
          oobIndex: oobIndex,
          event: event,
        );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'wins': wins,
      'ready': ready,
      'rank': rank,
      'points': points,
      'oobIndex': oobIndex,
      'event': event,
    };
  }

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      wins: json['wins'],
      ready: json['ready'],
      rank: json['rank'],
      points: json['points'],
      oobIndex: json['oobIndex'],
      event: json['event'],
    );
  }

  factory PlayerModel.empty() {
    return PlayerModel(
      id: '',
      name: '',
      image: '',
      wins: 0,
      ready: false,
      rank: 0,
      points: 0,
      oobIndex: 0,
      event: '',
    );
  }

  factory PlayerModel.fromEntity(PlayerEntity entity) {
    return PlayerModel(
      id: entity.id,
      name: entity.name,
      image: entity.image,
      wins: entity.wins,
      ready: entity.ready,
      rank: entity.rank,
      points: entity.points,
      oobIndex: entity.oobIndex,
      event: entity.event,
    );
  }

  PlayerModel copyWith({
    String? id,
    String? name,
    String? image,
    int? wins,
    bool? ready,
    int? rank,
    int? points,
    int? oobIndex,
    String? event,
  }) {
    return PlayerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      wins: wins ?? this.wins,
      ready: ready ?? this.ready,
      rank: rank ?? this.rank,
      points: points ?? this.points,
      oobIndex: oobIndex ?? this.oobIndex,
      event: event ?? this.event,
    );
  }

  bool compare(PlayerModel player) {
    return player.id == id &&
        player.name == name &&
        player.image == image &&
        player.wins == wins &&
        player.ready == ready &&
        player.rank == rank &&
        player.points == points &&
        player.oobIndex == oobIndex &&
        player.event == event;
  }
}
