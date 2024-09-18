import 'dart:math';

class SkockoApiService {
  List<int> getCombination() {
    return [
      Random().nextInt(6) + 1,
      Random().nextInt(6) + 1,
      Random().nextInt(6) + 1,
      Random().nextInt(6) + 1
    ];
  }

  List<int> guessCombination(List<int> combination, List<int> correct) {
    List<int> red = [];
    List<int> yellow = [];
    List<int> blank = [];
    List<int> checkedi = [];
    List<int> checkedj = [];

    for (int i = 0; i < combination.length; i++) {
      if (combination[i] == correct[i]) {
        red.add(1);
        checkedi.add(i);
        checkedj.add(i);
      }
    }

    for (int i = 0; i < combination.length; i++) {
      if (checkedi.contains(i)) continue;
      for (int j = 0; j < correct.length; j++) {
        if (combination[i] == correct[j] && !checkedj.contains(j)) {
          yellow.add(2);
          checkedi.add(i);
          checkedj.add(j);
          break;
        }
      }
    }

    List<int> result = red + yellow;

    if (result.length < 4) {
      for (int i = 0; i < 4 - result.length; i++) {
        blank.add(0);
      }
    }

    result += blank;

    return result;
  }
}
