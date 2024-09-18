import 'package:slagalica/core/usecases/use_case.dart';
import 'package:slagalica/features/skocko/data/models/guess_combination_model.dart';
import 'package:slagalica/features/skocko/data/repositories/skocko_repository_implementation.dart';

class GuessCombinationUseCase
    extends UseCaseWithParamsSync<List<int>, GuessCombinationModel> {
  SkockoRepositoryImplementation _repository;

  GuessCombinationUseCase(this._repository);

  @override
  List<int> call(GuessCombinationModel params) {
    return _repository.guessCombination(params);
  }
}
