import 'package:slagalica/features/skocko/data/data_source/skocko_api_service.dart';
import 'package:slagalica/features/skocko/data/models/guess_combination_model.dart';
import 'package:slagalica/features/skocko/domain/repositories/skocko_repository.dart';

class SkockoRepositoryImplementation extends SkockoRepository {
  final SkockoApiService _apiService;

  SkockoRepositoryImplementation(this._apiService);

  @override
  List<int> getCombination() {
    return _apiService.getCombination();
  }

  @override
  List<int> guessCombination(GuessCombinationModel guessCombinationModel) {
    return _apiService.guessCombination(
        guessCombinationModel.combination, guessCombinationModel.correct);
  }
}
