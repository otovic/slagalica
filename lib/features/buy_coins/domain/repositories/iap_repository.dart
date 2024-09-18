import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:slagalica/features/buy_coins/data/models/in_app_purchase_model.dart';

abstract class IapRepository {
  Future<void> buyCoins(InAppPurchaseModel data);
  Future<void> processPurchase(List<PurchaseDetails> coins);
}
