import 'package:slagalica/core/usecases/use_case.dart';
import 'package:slagalica/features/slagalica/data/repositories/slagalica_repository_implementation.dart';

class GetWordLengthUseCase extends UseCaseWithParamsSync<int, String> {
  SlagalicaRepositoryImplementation _repository;

  GetWordLengthUseCase(this._repository);

  @override
  int call(String word) {
    return _repository.getWordLength(word);
  }
}
