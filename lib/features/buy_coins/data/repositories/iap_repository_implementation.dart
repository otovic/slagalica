import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:slagalica/features/buy_coins/data/data_sources/remote/iap_api_service.dart';
import 'package:slagalica/features/buy_coins/data/models/in_app_purchase_model.dart';
import 'package:slagalica/features/buy_coins/domain/repositories/iap_repository.dart';

class IapRepositoryImplementation implements IapRepository {
  final IapApiService _iapApiService;

  IapRepositoryImplementation(this._iapApiService);

  @override
  Future<void> buyCoins(InAppPurchaseModel data) async {
    return await _iapApiService.buyCoins(data);
  }

  @override
  Future<bool> processPurchase(List<PurchaseDetails> coins) async {
    return await _iapApiService.processPurchase(coins);
  }
}
