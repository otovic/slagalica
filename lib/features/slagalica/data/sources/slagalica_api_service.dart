import 'dart:math';

class SlagalicaApiService {
  List<String> generateLetters() {
    const vowels = ['A', 'E', 'I', 'O', 'U'];
    const consonants = [
      'B',
      'V',
      'G',
      'D',
      'Đ',
      'Ž',
      'Z',
      'J',
      'K',
      'L',
      'LJ',
      'M',
      'N',
      'NJ',
      'P',
      'R',
      'S',
      'T',
      'Ć',
      'F',
      'H',
      'C',
      'Č',
      'DŽ',
      'Š'
    ];

    Random random = Random();

    List<String> selectedVowels = List<String>.generate(
        5, (index) => vowels[random.nextInt(vowels.length)]);

    List<String> selectedConsonants = List<String>.generate(
        7, (index) => consonants[random.nextInt(consonants.length)]);

    List<String> allLetters = [...selectedVowels, ...selectedConsonants];
    allLetters.shuffle(random);

    return allLetters;
  }

  int getWordLength(String word) {
    List<String> digraphs = ['lj', 'nj', 'dž'];

    int length = 0;

    for (int i = 0; i < word.length; i++) {
      if (i < word.length - 1) {
        String pair = word.substring(i, i + 2);
        if (digraphs.contains(pair)) {
          i++;
        } else {
          length++;
        }
      } else {
        length++;
      }
    }

    return length;
  }
}
