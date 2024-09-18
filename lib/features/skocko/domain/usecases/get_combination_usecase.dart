import 'package:slagalica/core/usecases/use_case.dart';
import 'package:slagalica/features/skocko/data/repositories/skocko_repository_implementation.dart';

class GetCombinationUseCase extends UseCaseNoParamsSync<List<int>> {
  final SkockoRepositoryImplementation _repository;

  GetCombinationUseCase(this._repository);

  @override
  List<int> call() {
    return _repository.getCombination();
  }
}
