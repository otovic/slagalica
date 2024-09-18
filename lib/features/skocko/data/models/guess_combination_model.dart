import 'package:slagalica/features/skocko/domain/entities/guess_combination.dart';

class GuessCombinationModel extends GuessCombinationEntity {
  GuessCombinationModel({
    required List<int> combination,
    required List<int> correct,
  }) : super(
          combination: combination,
          correct: correct,
        );
}
