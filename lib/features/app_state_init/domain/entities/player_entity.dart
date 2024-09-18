class PlayerEntity {
  final String id;
  final String name;
  final String image;
  final int wins;
  bool ready = false;
  final int rank;
  int points;
  int oobIndex = 0;
  String event = "";

  PlayerEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.wins,
    this.ready = false,
    required this.rank,
    required this.points,
    this.oobIndex = 0,
    this.event = "",
  });
}
