import 'package:slagalica/core/usecases/use_case.dart';
import 'package:slagalica/features/buy_coins/data/models/in_app_purchase_model.dart';
import 'package:slagalica/features/buy_coins/data/repositories/iap_repository_implementation.dart';

class MakePurchaseUseCase extends UseCaseWithParams<void, InAppPurchaseModel> {
  final IapRepositoryImplementation repository;

  MakePurchaseUseCase(this.repository);

  @override
  Future<void> call(InAppPurchaseModel params) async {
    return await repository.buyCoins(params);
  }
}
