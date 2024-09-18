import 'package:slagalica/features/skocko/data/models/guess_combination_model.dart';

abstract class SkockoRepository {
  List<int> getCombination();
  List<int> guessCombination(GuessCombinationModel guessCombinationModel);
}
