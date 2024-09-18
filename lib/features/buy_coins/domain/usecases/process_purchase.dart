import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:slagalica/core/usecases/use_case.dart';
import 'package:slagalica/features/buy_coins/data/repositories/iap_repository_implementation.dart';

class ProcessPurchaseUseCase
    extends UseCaseWithParams<void, List<PurchaseDetails>> {
  final IapRepositoryImplementation repository;

  ProcessPurchaseUseCase(this.repository);

  @override
  Future<bool> call(List<PurchaseDetails> params) async {
    return await repository.processPurchase(params);
  }
}
