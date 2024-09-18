import 'dart:math';

import 'package:slagalica/features/slagalica/data/sources/slagalica_api_service.dart';
import 'package:slagalica/features/slagalica/domain/repositories/slagalica_repository.dart';

class SlagalicaRepositoryImplementation extends SlagalicaRepository {
  final SlagalicaApiService _apiService;

  SlagalicaRepositoryImplementation(this._apiService);

  @override
  List<String> generateLetters() {
    return _apiService.generateLetters();
  }

  @override
  int getWordLength(String word) {
    return _apiService.getWordLength(word);
  }
}
