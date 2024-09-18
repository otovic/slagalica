class SlagalicaEntity {
  List<String> letters;
  String playerOneWord;
  bool playerOneWordExists = false;
  String playerTwoWord;
  bool playerTwoWordExists = false;
  int turn = 1;
  String event = '';

  SlagalicaEntity({
    required this.letters,
    required this.playerOneWord,
    required this.playerOneWordExists,
    required this.playerTwoWord,
    required this.playerTwoWordExists,
    this.turn = 1,
    this.event = '',
  });
}
