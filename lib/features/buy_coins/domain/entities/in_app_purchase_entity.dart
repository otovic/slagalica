class InAppPurchaseEntity {
  late final int coins;
  late final String productID;
  final int option;
  bool finished = false;

  InAppPurchaseEntity(this.option) {
    if (option == 1) {
      coins = 1;
      productID = 'single_token';
    }
    if (option == 2) {
      coins = 8;
      productID = 'eight_tokens';
    }
    if (option == 3) {
      coins = 100;
      productID = 'unlimited_tokens';
    }
  }
}
