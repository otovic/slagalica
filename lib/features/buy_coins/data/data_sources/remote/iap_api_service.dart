import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:slagalica/features/app_state_init/presentation/bloc/app_state_bloc.dart';
import 'package:slagalica/features/buy_coins/data/models/in_app_purchase_model.dart';

class IapApiService {
  late InAppPurchaseModel data;
  final AppStateBloc appStateBloc;

  IapApiService(this.appStateBloc);

  Future<void> buyCoins(InAppPurchaseModel data) async {
    final bool available = await InAppPurchase.instance.isAvailable();

    if (!available) {
      print('In App Purchase not available');
      return;
    }

    this.data = data;

    Set<String> ids = {data.productID};

    print("ID $ids");

    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(ids);

    if (response.notFoundIDs.isNotEmpty) {
      print('Product not found');
      throw Exception('Product not found');
    }

    List<ProductDetails> products = response.productDetails;

    final product = products.first;

    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    await InAppPurchase.instance
        .buyConsumable(purchaseParam: purchaseParam, autoConsume: true);
  }

  Future<bool> processPurchase(List<PurchaseDetails> purchases) async {
    PurchaseDetails purchase = purchases[0];
    if (purchase.status == PurchaseStatus.pending) {
      final bool success = await deliverPurchase();
      if (success) {
        await InAppPurchase.instance.completePurchase(purchase);
      }
    }
    if (purchase.status == PurchaseStatus.purchased) {
      if (!this.data.finished) {
        final bool success = await deliverPurchase();
        if (success) {
          this.data.finished = true;
          await InAppPurchase.instance.completePurchase(purchase);
        }
        return true;
      }
      return false;
    } else if (purchase.status == PurchaseStatus.error) {
      return false;
    } else {
      return false;
    }
  }

  Future<bool> deliverPurchase() async {
    final user = await FirebaseAuth.instance.currentUser;
    if (data.productID == "unlimited_tokens") {
      final date = await FirebaseFunctions.instanceFor(region: 'europe-west1')
          .httpsCallable('getServerTime')();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'unlimitedTokens': date,
      });
      return true;
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'coins': FieldValue.increment(data.coins),
      });
    }
    return true;
  }
}
