import 'package:slagalica/core/usecases/use_case.dart';
import 'package:slagalica/features/slagalica/data/repositories/slagalica_repository_implementation.dart';

class GenerateLettersUsecase extends UseCaseNoParamsSync<List<String>> {
  SlagalicaRepositoryImplementation _repository;

  GenerateLettersUsecase(this._repository);

  @override
  List<String> call() {
    return _repository.generateLetters();
  }
}
